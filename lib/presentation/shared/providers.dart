import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/hardware/hardware_bridge.dart';
import '../../core/services/hardware/hardware_bridge_service.dart';
import '../../data/datasources/local_storage_datasource.dart';
import '../../data/datasources/asset_curriculum_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../data/repositories/curriculum_repository_impl.dart';
import '../../domain/models/learner_profile_model.dart';
import '../../domain/models/learner_progress_model.dart';
import '../../domain/models/hardware_connection_model.dart';
import '../../domain/models/lesson_model.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/repositories/curriculum_repository.dart';
import '../../domain/models/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../data/datasources/settings_datasource.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/models/course_model.dart';
import '../../data/datasources/curriculum_data_engine.dart';
import '../../core/services/parent_session_service.dart';
import '../../core/services/component_restriction_service.dart';
import '../../core/services/sound_effects_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError(
      'storageServiceProvider must be initialized in main()');
});

final localStorageDataSourceProvider = Provider<LocalStorageDataSource>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return LocalStorageDataSource(storageService);
});

final progressCorruptionProvider = StreamProvider<String>((ref) {
  return ref.watch(localStorageDataSourceProvider).corruptionStream;
});

final storageCorruptionStreamProvider = progressCorruptionProvider;

final assetCurriculumDataSourceProvider =
    Provider<AssetCurriculumDataSource>((ref) {
  return AssetCurriculumDataSource();
});

final curriculumDataEngineProvider = Provider<CurriculumDataEngine>((ref) {
  final fallback = ref.watch(assetCurriculumDataSourceProvider);
  return CurriculumDataEngine(fallbackDataSource: fallback);
});

final curriculumHealthProvider =
    FutureProvider<CurriculumEngineStatus>((ref) async {
  final engine = ref.watch(curriculumDataEngineProvider);
  await engine.initialize();
  return engine.status;
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dataSource = ref.watch(localStorageDataSourceProvider);
  return ProfileRepositoryImpl(dataSource);
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final dataSource = ref.watch(localStorageDataSourceProvider);
  return ProgressRepositoryImpl(dataSource);
});

final curriculumRepositoryProvider = Provider<CurriculumRepository>((ref) {
  final engine = ref.watch(curriculumDataEngineProvider);
  return CurriculumRepositoryImpl(engine);
});

final parentSessionServiceProvider = Provider<ParentSessionService>((ref) {
  return appParentSessionService;
});

final parentSessionAuthStateProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(parentSessionServiceProvider);
  return service.authStateStream;
});

final componentRestrictionServiceProvider =
    Provider<ComponentRestrictionService>((ref) {
  return ComponentRestrictionService(null, ref.watch(storageServiceProvider));
});

class SafetyAuthorizationsNotifier extends StateNotifier<Map<String, bool>> {
  static const List<String> keys = ['laser', 'gas', 'relay'];
  final ComponentRestrictionService _service;

  SafetyAuthorizationsNotifier(this._service)
      : super({
          for (final key in keys) key: _service.isSafetyAuthorized(key),
        });

  Future<void> setAuthorized(String key, bool value) async {
    await _service.setSafetyAuthorized(key, value);
    state = {...state, key: value};
  }
}

final safetyAuthorizationsProvider =
    StateNotifierProvider<SafetyAuthorizationsNotifier, Map<String, bool>>(
        (ref) {
  return SafetyAuthorizationsNotifier(
    ref.watch(componentRestrictionServiceProvider),
  );
});

final nextLessonProvider = FutureProvider<Lesson?>((ref) async {
  final curriculumRepo = ref.watch(curriculumRepositoryProvider);
  final progress = ref.watch(activeProgressProvider);
  final sortedLessons = await curriculumRepo.getLessonsOrdered();

  for (final lesson in sortedLessons) {
    final isCompleted =
        progress?.completedLessonIds.contains(lesson.id) ?? false;
    if (isCompleted) continue;

    if (lesson.isOptional &&
        lesson.courseId != null &&
        (progress?.placementPassedCourseIds.contains(lesson.courseId!) ??
            false)) {
      continue;
    }

    final completedLessons = progress?.completedLessonIds ?? const <String>{};
    final completedCourses = progress?.completedCourseIds ?? const <String>{};
    final missingPrereqs = lesson.prerequisites.where(
      (req) =>
          !completedLessons.contains(req) && !completedCourses.contains(req),
    );
    if (missingPrereqs.isEmpty) {
      return lesson;
    }
  }
  return null;
});

final allProfilesProvider =
    FutureProvider<List<LearnerProfileModel>>((ref) async {
  final profileRepo = ref.watch(profileRepositoryProvider);
  return profileRepo.getAllProfiles();
});

final activeProfileProvider =
    StateNotifierProvider<ActiveProfileNotifier, LearnerProfileModel?>((ref) {
  final profileRepo = ref.watch(profileRepositoryProvider);
  return ActiveProfileNotifier(profileRepo);
});

class ActiveProfileNotifier extends StateNotifier<LearnerProfileModel?> {
  final ProfileRepository _profileRepo;

  ActiveProfileNotifier(this._profileRepo) : super(null) {
    loadActiveProfile();
  }

  Future<void> loadActiveProfile() async {
    final active = await _profileRepo.getActiveProfile();
    state = active;
  }

  Future<void> selectProfile(String profileId) async {
    await _profileRepo.setActiveProfile(profileId);
    final active = await _profileRepo.getActiveProfile();
    state = active;
  }

  Future<void> saveProfile(LearnerProfileModel profile,
      {bool setActive = false}) async {
    await _profileRepo.saveProfile(profile);
    if (setActive || state?.id == profile.id || state == null) {
      await _profileRepo.setActiveProfile(profile.id);
      state = profile;
    }
  }
}

final activeProgressProvider =
    StateNotifierProvider<ActiveProgressNotifier, LearnerProgressModel?>((ref) {
  final activeProfile = ref.watch(activeProfileProvider);
  final progressRepo = ref.watch(progressRepositoryProvider);
  return ActiveProgressNotifier(progressRepo, activeProfile?.id);
});

class ActiveProgressNotifier extends StateNotifier<LearnerProgressModel?> {
  final ProgressRepository _progressRepo;
  final String? _learnerId;

  ActiveProgressNotifier(this._progressRepo, this._learnerId) : super(null) {
    if (_learnerId != null) {
      loadProgress();
    }
  }

  Future<void> loadProgress() async {
    final learnerId = _learnerId;
    if (learnerId == null) return;
    final progress = await _progressRepo.getProgress(learnerId);
    state = progress;
  }

  Future<void> addXp(int xp) async {
    final learnerId = _learnerId;
    if (learnerId == null) return;
    await _progressRepo.addXp(learnerId, xp);
    await loadProgress();
  }

  Future<void> discoverComponent(String componentId,
      [int xpReward = 25]) async {
    final learnerId = _learnerId;
    if (learnerId == null) return;
    await _progressRepo.discoverComponent(learnerId, componentId, xpReward);
    await loadProgress();
  }

  Future<bool> completeLesson(String lessonId, int xpReward) async {
    final learnerId = _learnerId;
    if (learnerId == null) return false;
    final isFirst =
        await _progressRepo.completeLesson(learnerId, lessonId, xpReward);
    await loadProgress();
    return isFirst;
  }

  Future<bool> completeCourse(String courseId, int xpReward) async {
    final learnerId = _learnerId;
    if (learnerId == null) return false;
    final isFirst =
        await _progressRepo.completeCourse(learnerId, courseId, xpReward);
    await loadProgress();
    return isFirst;
  }

  Future<void> markPlacementPassed(String courseId) async {
    final learnerId = _learnerId;
    if (learnerId == null) return;
    await _progressRepo.markPlacementPassed(learnerId, courseId);
    await loadProgress();
  }

  Future<bool> completeProject(String projectId, int xpReward,
      [String? badgeId]) async {
    final learnerId = _learnerId;
    if (learnerId == null) return false;
    final isFirst = await _progressRepo.completeProject(
        learnerId, projectId, xpReward, badgeId);
    await loadProgress();
    return isFirst;
  }

  Future<bool> solveChallenge(String challengeId, int xpReward) async {
    final learnerId = _learnerId;
    if (learnerId == null) return false;
    final isFirst =
        await _progressRepo.solveChallenge(learnerId, challengeId, xpReward);
    await loadProgress();
    return isFirst;
  }

  Future<void> recordQuickCheckResult(QuickCheckResult result) async {
    final learnerId = _learnerId;
    if (learnerId == null) return;
    await _progressRepo.recordQuickCheckResult(learnerId, result);
    await loadProgress();
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return SettingsRepositoryImpl(SettingsDataSource(storageService));
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsRepository _repository;

  SettingsNotifier(this._repository) : super(_repository.getSettings());

  Future<void> setImmersiveLessonMode(bool value) async {
    await _repository.setImmersiveLessonMode(value);
    state = _repository.getSettings();
  }

  Future<void> setSoundEnabled(bool value) async {
    await _repository.setSoundEnabled(value);
    state = _repository.getSettings();
  }

  Future<void> setHighContrast(bool value) async {
    await _repository.setHighContrast(value);
    state = _repository.getSettings();
  }

  Future<void> setUiScale(double value) async {
    await _repository.setUiScale(value);
    state = _repository.getSettings();
  }

  Future<void> zoomIn() async {
    final current = state.uiScale > 0.0 ? state.uiScale : 0.80;
    final next = (current + 0.05).clamp(0.65, 1.25);
    await setUiScale(double.parse(next.toStringAsFixed(2)));
  }

  Future<void> zoomOut() async {
    final current = state.uiScale > 0.0 ? state.uiScale : 0.80;
    final next = (current - 0.05).clamp(0.65, 1.25);
    await setUiScale(double.parse(next.toStringAsFixed(2)));
  }

  Future<void> resetZoom() async {
    await setUiScale(0.0);
  }

  Future<void> setThemeMode(String mode) async {
    await _repository.setThemeMode(mode);
    state = _repository.getSettings();
  }

  Future<void> setThemePreset(String preset) async {
    await _repository.setThemePreset(preset);
    state = _repository.getSettings();
  }
}

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return SettingsNotifier(repo);
});

final soundEffectsProvider = Provider<SoundEffectsService>((ref) {
  final settings = ref.watch(settingsNotifierProvider);
  return SoundEffectsService(enabled: settings.soundEnabled);
});

final coursesProvider = FutureProvider<List<CourseModel>>((ref) async {
  final engine = ref.watch(curriculumDataEngineProvider);
  return engine.getCourses();
});

final orderedLessonsProvider = FutureProvider<List<Lesson>>((ref) async {
  final engine = ref.watch(curriculumDataEngineProvider);
  return engine.getLessonsOrdered();
});

typedef CurriculumTotals = ({
  int lessons,
  int projects,
  int components,
  int challenges,
});

final curriculumTotalsProvider = FutureProvider<CurriculumTotals>((ref) async {
  final repository = ref.watch(curriculumRepositoryProvider);
  final lessons = await repository.getLessons();
  final projects = await repository.getProjects();
  final components = await repository.getComponents();
  final challenges = await repository.getChallenges();

  return (
    lessons: lessons.length,
    projects: projects.length,
    components: components.length,
    challenges: challenges.length,
  );
});

final courseProgressProvider =
    FutureProvider.family<({int completed, int total}), String>(
        (ref, courseId) async {
  final engine = ref.watch(curriculumDataEngineProvider);
  final progress = ref.watch(activeProgressProvider);
  final lessons = await engine.getCourseLessons(courseId);
  final total = lessons.length;
  final completed = lessons
      .where((l) => progress?.completedLessonIds.contains(l.id) ?? false)
      .length;
  return (completed: completed, total: total);
});

final hardwareBridgeProvider = Provider<IHardwareBridge>((ref) {
  final bridge = HardwareBridgeService.createDefaultBridge();
  ref.onDispose(() => bridge.dispose());
  return bridge;
});

final hardwareStateStreamProvider =
    StreamProvider<HardwareConnectionState>((ref) {
  final bridge = ref.watch(hardwareBridgeProvider);
  return bridge.stateStream;
});

final hardwareTelemetryStreamProvider = StreamProvider<PinTelemetry>((ref) {
  final bridge = ref.watch(hardwareBridgeProvider);
  return bridge.telemetryStream;
});

class HardwareSerialLogsNotifier extends StateNotifier<List<SerialLogEntry>> {
  final IHardwareBridge _bridge;
  StreamSubscription<SerialLogEntry>? _sub;

  HardwareSerialLogsNotifier(this._bridge) : super(const []) {
    _sub = _bridge.serialStream.listen((entry) {
      state = [...state, entry];
      if (state.length > 300) {
        state = state.sublist(state.length - 300);
      }
    });
  }

  void clearLogs() {
    state = const [];
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final hardwareSerialLogsProvider =
    StateNotifierProvider<HardwareSerialLogsNotifier, List<SerialLogEntry>>(
        (ref) {
  final bridge = ref.watch(hardwareBridgeProvider);
  return HardwareSerialLogsNotifier(bridge);
});
