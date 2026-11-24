import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import '../../core/curriculum/curriculum_validator.dart';
import '../../domain/models/lesson_model.dart';
import '../../domain/models/component_model.dart';
import '../../domain/models/project_model.dart';
import '../../domain/models/challenge_model.dart';
import '../../domain/models/badge_model.dart';
import '../../domain/models/course_model.dart';
import 'asset_curriculum_datasource.dart';

class CurriculumLoadException implements Exception {
  final String message;
  final Object? cause;

  const CurriculumLoadException(this.message, {this.cause});

  @override
  String toString() =>
      'CurriculumLoadException: $message${cause != null ? ' (Cause: $cause)' : ''}';
}

enum CurriculumEngineStatus {
  uninitialized,
  initialized,
  fallbackActive,
  failed,
}

class CurriculumDataEngine {
  final AssetBundle _assetBundle;
  final AssetCurriculumDataSource _fallbackDataSource;
  final bool allowFallback;

  bool _isInitialized = false;
  bool _isFallbackActive = false;
  Object? _initializationError;
  Future<void>? _initFuture;
  final Map<String, CourseModel> _courses = {};
  final Map<String, Lesson> _lessons = {};
  final Map<String, ComponentModel> _components = {};
  final Map<String, ProjectModel> _projects = {};
  final Map<String, ChallengeModel> _challenges = {};
  final Map<String, BadgeModel> _badges = {};

  CurriculumDataEngine({
    AssetBundle? assetBundle,
    AssetCurriculumDataSource? fallbackDataSource,
    this.allowFallback = true,
  })  : _assetBundle = assetBundle ?? rootBundle,
        _fallbackDataSource = fallbackDataSource ?? AssetCurriculumDataSource();

  bool get isInitialized => _isInitialized;
  bool get isFallbackActive => _isFallbackActive;
  Object? get initializationError => _initializationError;

  CurriculumEngineStatus get status {
    if (_isInitialized) return CurriculumEngineStatus.initialized;
    if (_isFallbackActive) return CurriculumEngineStatus.fallbackActive;
    if (_initializationError != null) return CurriculumEngineStatus.failed;
    return CurriculumEngineStatus.uninitialized;
  }

  void reset() {
    _isInitialized = false;
    _isFallbackActive = false;
    _initializationError = null;
    _initFuture = null;
    _courses.clear();
    _lessons.clear();
    _components.clear();
    _projects.clear();
    _challenges.clear();
    _badges.clear();
  }

  Future<void> _ensureReady() async {
    if (!_isInitialized && !_isFallbackActive) {
      await initialize();
    }
  }

  /// Loads documents in bounded batches and yields between batches so other
  /// pending async work can progress during curriculum initialization.
  Future<void> _loadInBatches<T>({
    required List<String> ids,
    required String Function(String id) pathFor,
    required T Function(Map<String, dynamic> json) parse,
    required void Function(T entity) store,
  }) async {
    const batchSize = 8;
    for (var start = 0; start < ids.length; start += batchSize) {
      final end =
          start + batchSize < ids.length ? start + batchSize : ids.length;
      final raws = await Future.wait(<Future<String>>[
        for (var index = start; index < end; index++)
          _assetBundle.loadString(pathFor(ids[index])),
      ]);
      for (final raw in raws) {
        store(parse(jsonDecode(raw) as Map<String, dynamic>));
      }
      // A microtask yield keeps widget tests (fake async) progressing without
      // needing an explicit timer pump.
      await Future<void>.value();
    }
  }

  /// Loads and validates all curriculum JSON files from assets
  Future<void> initialize() {
    if (_isInitialized || _isFallbackActive) return Future.value();
    return _initFuture ??= _performInitialize();
  }

  Future<void> _performInitialize() async {
    try {
      final manifestJson =
          await _assetBundle.loadString('assets/curriculum/manifest.json');
      final manifest = jsonDecode(manifestJson) as Map<String, dynamic>;

      // 1. Load Badges
      try {
        final badgesJson = await _assetBundle
            .loadString('assets/curriculum/badges/badges.json');
        final badgeList = jsonDecode(badgesJson) as List<dynamic>;
        for (final item in badgeList) {
          final badge = BadgeModel.fromJson(item as Map<String, dynamic>);
          _badges[badge.id] = badge;
        }
      } catch (_) {
        // Badges optional in fallback
      }

      // 1.5. Load Courses
      try {
        if (manifest['courses'] != null) {
          await _loadInBatches<CourseModel>(
            ids: List<String>.from(manifest['courses'] as List),
            pathFor: (cid) => 'assets/curriculum/courses/$cid.json',
            parse: CourseModel.fromJson,
            store: (course) => _courses[course.id] = course,
          );
        }
      } catch (_) {
        // Courses optional during tests
      }

      // 2. Load Components in batches yielding to the event queue
      final compIds = List<String>.from(manifest['components'] as List);
      await _loadInBatches<ComponentModel>(
        ids: compIds,
        loadString: (cid) =>
            _assetBundle.loadString('assets/curriculum/components/$cid.json'),
        parser: ComponentModel.fromJson,
        onLoaded: (comp) => _components[comp.id] = comp,
      );

      // 3. Load Lessons in batches yielding to the event queue
      final lessonIds = List<String>.from(manifest['lessons'] as List);
      await _loadInBatches<Lesson>(
        ids: lessonIds,
        loadString: (lid) =>
            _assetBundle.loadString('assets/curriculum/lessons/$lid.json'),
        parser: Lesson.fromJson,
        onLoaded: (lesson) => _lessons[lesson.id] = lesson,
      );

      // 4. Load Projects in batches yielding to the event queue
      final projectIds = List<String>.from(manifest['projects'] as List);
      await _loadInBatches<ProjectModel>(
        ids: projectIds,
        loadString: (pid) =>
            _assetBundle.loadString('assets/curriculum/projects/$pid.json'),
        parser: ProjectModel.fromJson,
        onLoaded: (project) => _projects[project.id] = project,
      );

      // 5. Load Challenges in batches yielding to the event queue
      final challengeIds = List<String>.from(manifest['challenges'] as List);
      await _loadInBatches<ChallengeModel>(
        ids: challengeIds,
        loadString: (chid) =>
            _assetBundle.loadString('assets/curriculum/challenges/$chid.json'),
        parser: ChallengeModel.fromJson,
        onLoaded: (challenge) => _challenges[challenge.id] = challenge,
      );

      // 6. Validate Curriculum Integrity
      CurriculumValidator.validateCurriculumIntegrity(
        lessons: _lessons.values.toList(),
        components: _components.values.toList(),
        projects: _projects.values.toList(),
        challenges: _challenges.values.toList(),
        badges: _badges.values.toList(),
        courses: _courses.values.toList(),
        manifest: manifest,
      );

      _isInitialized = true;
      _isFallbackActive = false;
      _initializationError = null;
    } catch (e) {
      _initializationError = e;
      _isInitialized = false;
      if (allowFallback) {
        _populateFromFallback();
        _isFallbackActive = true;
      } else {
        _isFallbackActive = false;
        throw CurriculumLoadException(
          'Failed to load production curriculum assets: $e',
          cause: e,
        );
      }
    }
  }

  Future<void> _loadInBatches<T>({
    required List<String> ids,
    required Future<String> Function(String id) loadString,
    required T Function(Map<String, dynamic> json) parser,
    required void Function(T item) onLoaded,
    int batchSize = 15,
  }) async {
    for (int i = 0; i < ids.length; i += batchSize) {
      final end = (i + batchSize < ids.length) ? i + batchSize : ids.length;
      final batchIds = ids.sublist(i, end);
      final batchJsons = await Future.wait(batchIds.map(loadString));
      for (final jsonStr in batchJsons) {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        onLoaded(parser(map));
      }
      if (end < ids.length) {
        final isTest =
            !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');
        if (!isTest) {
          await Future<void>.delayed(Duration.zero);
        }
      }
    }
  }

  void _populateFromFallback() {
    try {
      for (final c in _fallbackDataSource.getBaselineCourses()) {
        _courses[c.id] = c;
      }
    } catch (_) {}
    for (final l in _fallbackDataSource.getBaselineLessons()) {
      _lessons[l.id] = l;
    }
    for (final c in _fallbackDataSource.getBaselineComponents()) {
      _components[c.id] = c;
    }
    for (final p in _fallbackDataSource.getBaselineProjects()) {
      _projects[p.id] = p;
    }
    for (final ch in _fallbackDataSource.getBaselineChallenges()) {
      _challenges[ch.id] = ch;
    }
  }

  /// Inject or replace a lesson dynamically (e.g. from runtime DLC, custom user pack)
  void injectLesson(Lesson lesson) {
    CurriculumValidator.validateLesson(lesson);
    _lessons[lesson.id] = lesson;
  }

  /// Inject or replace a component dynamically
  void injectComponent(ComponentModel component) {
    CurriculumValidator.validateComponent(component);
    _components[component.id] = component;
  }

  /// Inject or replace a project dynamically
  void injectProject(ProjectModel project) {
    CurriculumValidator.validateProject(project);
    _projects[project.id] = project;
  }

  // --- Query Methods ---

  Future<List<CourseModel>> getCourses() async {
    await _ensureReady();
    return _courses.values.toList();
  }

  Future<CourseModel> getCourseById(String id) async {
    await _ensureReady();
    final course = _courses[id];
    if (course == null) {
      throw Exception('Course $id not found in curriculum engine');
    }
    return course;
  }

  Future<List<Lesson>> getCourseLessons(String courseId) async {
    await _ensureReady();
    final list = _lessons.values.where((l) => l.courseId == courseId).toList();
    list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return list;
  }

  Future<List<Lesson>> getLessonsOrdered() async {
    await _ensureReady();

    final standalone = <Lesson>[];
    final courseLessons = <String, List<Lesson>>{};

    for (final lesson in _lessons.values) {
      if (lesson.courseId == null) {
        standalone.add(lesson);
      } else {
        courseLessons.putIfAbsent(lesson.courseId!, () => []).add(lesson);
      }
    }

    standalone.sort((a, b) => a.id.compareTo(b.id));

    for (final list in courseLessons.values) {
      list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    }

    final result = <Lesson>[];

    for (final course in _courses.values) {
      if (courseLessons.containsKey(course.id)) {
        result.addAll(courseLessons[course.id]!);
      }
    }

    result.addAll(standalone);

    return result;
  }

  Future<List<Lesson>> getLessons({DifficultyTier? tier}) async {
    await _ensureReady();
    final list = _lessons.values.toList();
    if (tier == null) return list;
    return list.where((l) => l.tier == tier).toList();
  }

  Future<Lesson> getLessonById(String id) async {
    await _ensureReady();
    final lesson = _lessons[id];
    if (lesson == null) {
      throw Exception('Lesson $id not found in curriculum engine');
    }
    return lesson;
  }

  Future<List<ComponentModel>> getComponents({String? category}) async {
    await _ensureReady();
    final list = _components.values.toList();
    if (category == null) return list;
    return list.where((c) => c.category == category).toList();
  }

  Future<ComponentModel> getComponentById(String id) async {
    await _ensureReady();
    final component = _components[id];
    if (component == null) {
      throw Exception('Component $id not found in curriculum engine');
    }
    return component;
  }

  Future<List<ProjectModel>> getProjects({DifficultyTier? tier}) async {
    await _ensureReady();
    final list = _projects.values.toList();
    if (tier == null) return list;
    return list.where((p) => p.tier == tier).toList();
  }

  Future<ProjectModel> getProjectById(String id) async {
    await _ensureReady();
    final project = _projects[id];
    if (project == null) {
      throw Exception('Project $id not found in curriculum engine');
    }
    return project;
  }

  Future<List<ChallengeModel>> getChallenges({DifficultyTier? tier}) async {
    await _ensureReady();
    final list = _challenges.values.toList();
    if (tier == null) return list;
    return list.where((c) => c.difficulty == tier).toList();
  }

  Future<ChallengeModel> getChallengeById(String id) async {
    await _ensureReady();
    final challenge = _challenges[id];
    if (challenge == null) {
      throw Exception('Challenge $id not found in curriculum engine');
    }
    return challenge;
  }

  Future<List<BadgeModel>> getBadges({DifficultyTier? tier}) async {
    await _ensureReady();
    final list = _badges.values.toList();
    if (tier == null) return list;
    return list.where((b) => b.tier == tier).toList();
  }

  Future<BadgeModel> getBadgeById(String id) async {
    await _ensureReady();
    final badge = _badges[id];
    if (badge == null) {
      throw Exception('Badge $id not found in curriculum engine');
    }
    return badge;
  }
}
