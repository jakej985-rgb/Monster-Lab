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
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/repositories/curriculum_repository.dart';

import '../../data/datasources/curriculum_data_engine.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError(
      'storageServiceProvider must be initialized in main()');
});

final localStorageDataSourceProvider = Provider<LocalStorageDataSource>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return LocalStorageDataSource(storageService);
});

final assetCurriculumDataSourceProvider =
    Provider<AssetCurriculumDataSource>((ref) {
  return AssetCurriculumDataSource();
});

final curriculumDataEngineProvider = Provider<CurriculumDataEngine>((ref) {
  final fallback = ref.watch(assetCurriculumDataSourceProvider);
  return CurriculumDataEngine(fallbackDataSource: fallback);
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

  Future<void> saveProfile(LearnerProfileModel profile) async {
    await _profileRepo.saveProfile(profile);
    if (state?.id == profile.id || state == null) {
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

  Future<void> solveChallenge(String challengeId, int xpReward) async {
    final learnerId = _learnerId;
    if (learnerId == null) return;
    await _progressRepo.solveChallenge(learnerId, challengeId, xpReward);
    await loadProgress();
  }
}

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
