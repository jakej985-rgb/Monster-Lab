import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/curriculum/curriculum_validator.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/domain/models/component_model.dart';
import 'package:monster_lab/domain/models/course_model.dart';
import 'package:monster_lab/domain/models/lesson_model.dart';

class InMemoryAssetBundle extends CachingAssetBundle {
  final Map<String, String> assets;

  InMemoryAssetBundle(this.assets);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (assets.containsKey(key)) {
      return assets[key]!;
    }
    throw Exception('Asset not found: $key');
  }

  @override
  Future<ByteData> load(String key) async {
    final str = await loadString(key);
    final bytes = utf8.encode(str);
    return ByteData.view(Uint8List.fromList(bytes).buffer);
  }
}

class LocalDiskAssetBundle extends CachingAssetBundle {
  final String basePath;

  LocalDiskAssetBundle([this.basePath = '.']);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final file = File('$basePath/$key');
    if (await file.exists()) {
      return file.readAsString();
    }
    throw Exception('Asset not found: $key (tried $basePath/$key)');
  }

  @override
  Future<ByteData> load(String key) async {
    final file = File('$basePath/$key');
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      return ByteData.view(bytes.buffer);
    }
    throw Exception('Asset not found: $key');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Curriculum Integrity Regression Suite (Issues #10-#15)', () {
    // --- Issue #10: Production Fallback Elimination ---
    group('Issue #10: Production Fallback & Initialization Status', () {
      test('fails fast in strict production mode (allowFallback: false)',
          () async {
        final bundle = InMemoryAssetBundle({
          'assets/curriculum/manifest.json': '{"corrupt": json',
        });
        final engine = CurriculumDataEngine(
          assetBundle: bundle,
          allowFallback: false,
        );

        await expectLater(
          engine.initialize(),
          throwsA(isA<CurriculumLoadException>().having(
            (e) => e.message,
            'message',
            contains('Failed to load production curriculum assets'),
          )),
        );
        expect(engine.isInitialized, isFalse);
        expect(engine.isFallbackActive, isFalse);
        expect(engine.status, equals(CurriculumEngineStatus.failed));
      });

      test('populates baseline but NEVER marks isInitialized true on fallback',
          () async {
        final bundle = InMemoryAssetBundle({
          // Empty bundle to trigger asset loading exception
        });
        final engine = CurriculumDataEngine(
          assetBundle: bundle,
          allowFallback: true,
        );

        await engine.initialize();

        // Must NOT mark initialization successful after fallback
        expect(engine.isInitialized, isFalse);
        expect(engine.isFallbackActive, isTrue);
        expect(engine.status, equals(CurriculumEngineStatus.fallbackActive));
        expect(engine.initializationError, isNotNull);

        // Fallback data is available for graceful testing
        final lessons = await engine.getLessons();
        expect(lessons, isNotEmpty);
      });

      test('marks isInitialized true when production assets load cleanly',
          () async {
        final engine = CurriculumDataEngine(
          assetBundle: LocalDiskAssetBundle(),
          allowFallback: false,
        );

        await engine.initialize();
        expect(engine.isInitialized, isTrue);
        expect(engine.isFallbackActive, isFalse);
        expect(engine.status, equals(CurriculumEngineStatus.initialized));
        expect(engine.initializationError, isNull);
      });
    });

    // --- Issue #11: Dart & Python Rule Parity ---
    group('Issue #11: Validator Rule Parity & Diagnostics', () {
      test('rejects courses with short title or summary', () {
        const invalidCourse = CourseModel(
          id: 'lesson_01',
          title: 'AB', // < 3 chars
          summary: '',
          lessonIds: ['l01_01'],
          isOptional: false,
          prerequisites: [],
          xpReward: 100,
          estimatedMinutes: 30,
        );

        expect(
          () => CurriculumValidator.validateCourse(invalidCourse),
          throwsA(isA<CurriculumValidationException>().having(
            (e) => e.details,
            'details',
            containsAll([
              'Course title must be at least 3 characters',
              'Course summary cannot be empty',
            ]),
          )),
        );
      });

      test('rejects lessons with invalid estimatedMinutes bounds', () {
        const invalidLesson = Lesson(
          id: 'lesson_01',
          title: 'Valid Lesson Title',
          summary: 'Valid summary text here',
          tier: DifficultyTier.rookie,
          estimatedMinutes: 200, // > 120
          prerequisites: [],
          componentIds: [],
          steps: [
            LessonStep(
              stepId: 's1',
              title: 'Step 1',
              type: StepType.story,
              markdownContent: 'Content here',
            ),
          ],
          xpReward: 50,
        );

        expect(
          () => CurriculumValidator.validateLesson(invalidLesson),
          throwsA(isA<CurriculumValidationException>().having(
            (e) => e.details,
            'details',
            contains('estimatedMinutes must be between 5 and 120 (got 200)'),
          )),
        );
      });
    });

    // --- Issue #12: Manifest Counts and Unique Identifiers ---
    group('Issue #12: Manifest Counts & Unique Identifier Validation', () {
      test('detects count mismatch between manifest and loaded entities', () {
        final manifest = {
          'counts': {
            'courses': 2,
            'lessons': 10,
            'components': 5,
            'projects': 1,
            'challenges': 1,
            'badges': 1,
          },
        };

        expect(
          () => CurriculumValidator.validateManifestCounts(
            manifest: manifest,
            courseCount: 2,
            lessonCount: 9, // mismatch (expected 10)
            componentCount: 5,
            projectCount: 1,
            challengeCount: 1,
            badgeCount: 1,
          ),
          throwsA(isA<CurriculumValidationException>().having(
            (e) => e.details,
            'details',
            contains(
                "Manifest count mismatch for 'lessons': expected 10, found 9"),
          )),
        );
      });

      test('detects duplicate identifiers within entity groups', () {
        const lesson1 = Lesson(
          id: 'l01_01',
          title: 'Lesson 1',
          summary: 'Summary 1',
          tier: DifficultyTier.rookie,
          estimatedMinutes: 10,
          prerequisites: [],
          componentIds: [],
          steps: [
            LessonStep(
              stepId: 's1',
              title: 'Step 1',
              type: StepType.story,
              markdownContent: 'Content',
            ),
          ],
          xpReward: 20,
        );

        const lessonDuplicate = Lesson(
          id: 'l01_01', // Duplicate ID
          title: 'Lesson 1 Clone',
          summary: 'Summary 1 Clone',
          tier: DifficultyTier.rookie,
          estimatedMinutes: 10,
          prerequisites: [],
          componentIds: [],
          steps: [
            LessonStep(
              stepId: 's1',
              title: 'Step 1',
              type: StepType.story,
              markdownContent: 'Content',
            ),
          ],
          xpReward: 20,
        );

        expect(
          () => CurriculumValidator.validateUniqueIdentifiers(
            lessons: [lesson1, lessonDuplicate],
          ),
          throwsA(isA<CurriculumValidationException>().having(
            (e) => e.details,
            'details',
            contains("Duplicate Lesson identifier detected: 'l01_01'"),
          )),
        );
      });
    });

    // --- Issue #13: Prerequisite Cycles and Orphaned References ---
    group('Issue #13: Prerequisite Cycles & Orphaned Node Detection', () {
      test('detects simple 2-node prerequisite cycles', () {
        final graph = {
          'l01_01': ['l01_02'],
          'l01_02': ['l01_01'],
        };

        final cycles = CurriculumValidator.detectPrerequisiteCycles(graph);
        expect(cycles, isNotEmpty);
        expect(cycles.first, equals('l01_01 -> l01_02 -> l01_01'));
      });

      test('detects 3-node transitive prerequisite cycles', () {
        final graph = {
          'node_a': ['node_b'],
          'node_b': ['node_c'],
          'node_c': ['node_a'],
        };

        final cycles = CurriculumValidator.detectPrerequisiteCycles(graph);
        expect(cycles, isNotEmpty);
        expect(cycles.first, equals('node_a -> node_b -> node_c -> node_a'));
      });

      test('validates valid acyclic prerequisite graphs without error', () {
        final graph = {
          'lesson_01': <String>[],
          'lesson_02': ['lesson_01'],
          'lesson_03': ['lesson_01', 'lesson_02'],
        };

        final cycles = CurriculumValidator.detectPrerequisiteCycles(graph);
        expect(cycles, isEmpty);
      });
    });

    // --- Issue #14: Media Paths & Interactive Activities ---
    group('Issue #14: Media Paths & Interactive Activity Configurations', () {
      test(
          'detects missing media asset paths when fileExistsChecker returns false',
          () {
        const component = ComponentModel(
          id: 'comp_test',
          peripheralNumber: 1,
          name: 'Test Sensor',
          partNumber: 'TS-01',
          category: 'sensor',
          description: 'A test sensor',
          realWorldAnalogy: 'Like a thermometer',
          voltage: OperatingVoltage.v5,
          pinout: [],
          safety: SafetyClassification(
            level: SafetyLevel.safe,
            hazards: [],
            requiresParentUnlock: false,
          ),
          projectIds: [],
          primaryImage: 'assets/images/components/non_existent_image.webp',
        );

        expect(
          () => CurriculumValidator.validateMediaPaths(
            components: [component],
            badges: [],
            fileExistsChecker: (path) =>
                path != 'assets/images/components/non_existent_image.webp',
          ),
          throwsA(isA<CurriculumValidationException>().having(
            (e) => e.details.first,
            'first detail',
            contains("references non-existent media path"),
          )),
        );
      });

      test('validates interactive widget types against identifier format', () {
        const invalidLesson = Lesson(
          id: 'l01_01',
          title: 'Lesson Title',
          summary: 'Summary text',
          tier: DifficultyTier.rookie,
          estimatedMinutes: 10,
          prerequisites: [],
          componentIds: [],
          steps: [
            LessonStep(
              stepId: 's1',
              title: 'Step 1',
              type: StepType.codeExperiment,
              markdownContent: 'Content',
              interactiveWidgetType: 'invalid widget name with spaces!',
            ),
          ],
          xpReward: 20,
        );

        expect(
          () => CurriculumValidator.validateInteractiveActivities(
              [invalidLesson]),
          throwsA(isA<CurriculumValidationException>().having(
            (e) => e.details.first,
            'first detail',
            contains("has invalid interactiveWidgetType"),
          )),
        );
      });
    });

    // --- Issue #15: Live Repository Curriculum Validation ---
    group('Issue #15: Full Live Curriculum Regression', () {
      test(
          'live disk curriculum satisfies 100% of all integrity rules and counts',
          () async {
        final engine = CurriculumDataEngine(
          assetBundle: LocalDiskAssetBundle(),
          allowFallback: false,
        );
        await engine.initialize();
        expect(engine.isInitialized, isTrue);

        final courses = await engine.getCourses();
        final lessons = await engine.getLessons();
        final components = await engine.getComponents();
        final projects = await engine.getProjects();
        final challenges = await engine.getChallenges();
        final badges = await engine.getBadges();

        expect(courses.length, equals(14));
        expect(lessons.length, equals(141));
        expect(components.length, equals(54));
        expect(projects.length, equals(20));
        expect(challenges.length, equals(24));
        expect(badges.length, equals(20));

        // Media paths validation on live files
        expect(
          () => CurriculumValidator.validateMediaPaths(
            components: components,
            badges: badges,
            lessons: lessons,
            projects: projects,
            fileExistsChecker: (path) => File(path).existsSync(),
          ),
          returnsNormally,
        );
      });
    });
  });
}
