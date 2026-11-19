import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/curriculum/curriculum_validator.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/domain/models/course_model.dart';
import 'package:monster_lab/domain/models/lesson_model.dart';
import 'package:monster_lab/domain/models/component_model.dart';

class FailingAssetBundle extends CachingAssetBundle {
  final Map<String, String> files;

  FailingAssetBundle(this.files);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (files.containsKey(key)) {
      return files[key]!;
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Curriculum Loader Failure-Path & Diagnostics Suite (Issue #46)', () {
    test(
        'Missing manifest file throws CurriculumLoadException when fallback disabled',
        () async {
      final bundle = FailingAssetBundle({});
      final engine = CurriculumDataEngine(
        assetBundle: bundle,
        allowFallback: false,
      );

      expect(
        () => engine.initialize(),
        throwsA(isA<CurriculumLoadException>()),
      );
      try {
        await engine.initialize();
      } catch (_) {}

      expect(engine.isInitialized, isFalse);
      expect(engine.status, equals(CurriculumEngineStatus.failed));
      expect(engine.initializationError, isNotNull);
    });

    test(
        'Malformed JSON in manifest triggers explicit load exception with diagnostic context',
        () async {
      final bundle = FailingAssetBundle({
        'assets/curriculum/manifest.json':
            '{ "courses": [ { "id": "lesson_01", malformed_json... ',
      });
      final engine = CurriculumDataEngine(
        assetBundle: bundle,
        allowFallback: false,
      );

      expect(
        () => engine.initialize(),
        throwsA(isA<CurriculumLoadException>()),
      );
    });

    test(
        'Validator rejects Course with empty title or no lessons with actionable details',
        () {
      const invalidCourse = CourseModel(
        id: 'lesson_01',
        title: ' ',
        summary: 'A short course',
        lessonIds: [],
        prerequisites: [],
        xpReward: 100,
        estimatedMinutes: 60,
      );

      expect(
        () => CurriculumValidator.validateCourse(invalidCourse),
        throwsA(
          predicate<CurriculumValidationException>((e) {
            return e.entityId == 'lesson_01' &&
                e.entityType == 'Course' &&
                e.details.any((d) => d.contains('title')) &&
                e.details.any((d) => d.contains('lessonId'));
          }),
        ),
      );
    });

    test('Validator rejects Lesson with empty steps or negative XP reward', () {
      const invalidLesson = Lesson(
        id: 'lesson_01',
        title: 'Invalid Lesson',
        summary: 'Has no steps and negative XP',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 10,
        prerequisites: [],
        componentIds: [],
        steps: [],
        xpReward: -20,
      );

      expect(
        () => CurriculumValidator.validateLesson(invalidLesson),
        throwsA(
          predicate<CurriculumValidationException>((e) {
            return e.entityId == 'lesson_01' &&
                e.entityType == 'Lesson' &&
                e.details.any((d) => d.contains('step')) &&
                e.details.any((d) => d.contains('xpReward'));
          }),
        ),
      );
    });

    test(
        'Validator rejects Component with invalid identifier pattern or empty description',
        () {
      const invalidComponent = ComponentModel(
        id: 'INVALID_ID_CAPS',
        peripheralNumber: 1,
        name: 'Bad Resistor',
        partNumber: 'RES-10K',
        category: 'passives',
        description: '',
        realWorldAnalogy: '',
        voltage: OperatingVoltage.v5,
        safety: SafetyClassification(
          level: SafetyLevel.safe,
          hazards: [],
          requiresParentUnlock: false,
        ),
        projectIds: [],
        pinout: [],
      );

      expect(
        () => CurriculumValidator.validateComponent(invalidComponent),
        throwsA(
          predicate<CurriculumValidationException>((e) {
            return e.entityId == 'INVALID_ID_CAPS' &&
                e.entityType == 'Component' &&
                e.details.any((d) => d.contains('pattern')) &&
                e.details.any((d) => d.contains('description'));
          }),
        ),
      );
    });

    test(
        'DataEngine falls back cleanly when allowFallback is true and records fallback status',
        () async {
      // Simulates missing disk assets, triggering fallback data source
      final bundle = FailingAssetBundle({});
      final engine = CurriculumDataEngine(
        assetBundle: bundle,
        allowFallback: true,
      );

      await engine.initialize();
      expect(engine.isFallbackActive, isTrue);
      expect(engine.isInitialized, isFalse);
      expect(engine.status, equals(CurriculumEngineStatus.fallbackActive));
      // Fallback data is still queryable
      final lessons = await engine.getLessons();
      expect(lessons, isNotEmpty);
    });
  });
}
