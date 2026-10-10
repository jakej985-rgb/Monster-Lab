import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/curriculum/curriculum_validator.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/domain/models/lesson_model.dart';
import 'package:monster_lab/domain/models/project_model.dart';

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

  group('CurriculumValidator Tests', () {
    test('validates correct lesson successfully', () {
      const lesson = Lesson(
        id: 'lesson_01',
        title: 'Introduction to Monster Lab',
        summary: 'A friendly starter lesson',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 15,
        prerequisites: [],
        componentIds: [],
        steps: [
          LessonStep(
            stepId: 'step_1',
            title: 'Welcome',
            type: StepType.story,
            markdownContent: 'Welcome to Monster Lab!',
          ),
        ],
        xpReward: 50,
      );

      expect(() => CurriculumValidator.validateLesson(lesson), returnsNormally);
    });

    test('rejects lesson with invalid ID pattern', () {
      const lesson = Lesson(
        id: 'invalid-id-format',
        title: 'Invalid ID Lesson',
        summary: 'This has an invalid ID',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 15,
        prerequisites: [],
        componentIds: [],
        steps: [
          LessonStep(
            stepId: 'step_1',
            title: 'Welcome',
            type: StepType.story,
            markdownContent: 'Hello',
          ),
        ],
        xpReward: 50,
      );

      expect(
        () => CurriculumValidator.validateLesson(lesson),
        throwsA(isA<CurriculumValidationException>().having(
          (e) => e.details.any((d) => d.contains("does not match pattern")),
          'contains pattern error',
          isTrue,
        )),
      );
    });

    test('rejects lesson with empty steps', () {
      const lesson = Lesson(
        id: 'lesson_99',
        title: 'Empty Step Lesson',
        summary: 'Has no steps',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 15,
        prerequisites: [],
        componentIds: [],
        steps: [],
        xpReward: 50,
      );

      expect(
        () => CurriculumValidator.validateLesson(lesson),
        throwsA(isA<CurriculumValidationException>().having(
          (e) =>
              e.details.any((d) => d.contains("must contain at least 1 step")),
          'contains step error',
          isTrue,
        )),
      );
    });

    test('rejects referential integrity violation (missing prerequisite)', () {
      const lesson = Lesson(
        id: 'lesson_02',
        title: 'Step Two',
        summary: 'Has missing prereq',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 15,
        prerequisites: ['lesson_nonexistent'],
        componentIds: [],
        steps: [
          LessonStep(
            stepId: 's1',
            title: 'Intro',
            type: StepType.story,
            markdownContent: 'Text',
          ),
        ],
        xpReward: 50,
      );

      expect(
        () => CurriculumValidator.validateCurriculumIntegrity(
          lessons: [lesson],
          components: [],
          projects: [],
          challenges: [],
          badges: [],
        ),
        throwsA(isA<CurriculumValidationException>().having(
          (e) => e.details.any(
              (d) => d.contains("missing prerequisite 'lesson_nonexistent'")),
          'contains missing prereq error',
          isTrue,
        )),
      );
    });

    test('rejects project referencing missing component', () {
      const project = ProjectModel(
        id: 'proj_01',
        title: 'Broken Project',
        tagline: 'Broken project tagline',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 30,
        requiredComponents: ['comp_missing'],
        prerequisiteLessons: [],
        phases: [
          BuildPhase(
              phaseNumber: 1,
              phaseTitle: 'P1',
              type: PhaseType.gatherParts,
              instructions: 'Inst'),
          BuildPhase(
              phaseNumber: 2,
              phaseTitle: 'P2',
              type: PhaseType.missionComplete,
              instructions: 'Inst'),
        ],
        xpReward: 100,
      );

      expect(
        () => CurriculumValidator.validateCurriculumIntegrity(
          lessons: [],
          components: [],
          projects: [project],
          challenges: [],
          badges: [],
        ),
        throwsA(isA<CurriculumValidationException>().having(
          (e) => e.details.any((d) => d.contains(
              "references missing required component 'comp_missing'")),
          'contains missing component error',
          isTrue,
        )),
      );
    });
  });

  group('CurriculumDataEngine Live Assets Test', () {
    late CurriculumDataEngine engine;

    setUp(() {
      engine = CurriculumDataEngine(assetBundle: LocalDiskAssetBundle());
    });

    test('loads and validates all 100% baseline JSON assets from disk',
        () async {
      await engine.initialize();
      expect(engine.isInitialized, isTrue);

      final lessons = await engine.getLessons();
      expect(lessons.length, equals(139));
      expect(lessons.first.id, equals('l01_01'));
      expect(lessons.first.title, contains('Arduino'));

      final components = await engine.getComponents();
      expect(components.length, equals(54));
      expect(components.first.id, equals('comp_01'));

      final projects = await engine.getProjects();
      expect(projects.length, equals(20));
      expect(projects.first.id, equals('proj_01'));

      final challenges = await engine.getChallenges();
      expect(challenges.length, equals(24));

      final badges = await engine.getBadges();
      expect(badges.length, equals(20));
    });

    test('loads project variants and engineering missions', () async {
      final proj01 = await engine.getProjectById('proj_01');
      expect(proj01.variants.isNotEmpty, isTrue);
      expect(proj01.extensionMissions.isNotEmpty, isTrue);

      final proj15 = await engine.getProjectById('proj_15');
      expect(proj15.variants.isNotEmpty, isTrue);
      expect(proj15.extensionMissions.isNotEmpty, isTrue);
    });

    test('filters lessons, projects, and components by tier or category',
        () async {
      final rookieLessons =
          await engine.getLessons(tier: DifficultyTier.rookie);
      expect(
          rookieLessons.every((l) => l.tier == DifficultyTier.rookie), isTrue);

      final masterProjects =
          await engine.getProjects(tier: DifficultyTier.monsterMaster);
      expect(masterProjects.length, equals(3));
      expect(masterProjects.map((p) => p.id),
          containsAll(['proj_13', 'proj_14', 'proj_20']));

      final sensorComponents = await engine.getComponents(category: 'sensor');
      expect(sensorComponents.every((c) => c.category == 'sensor'), isTrue);
      expect(sensorComponents.length, greaterThanOrEqualTo(15));
    });

    test('proves extensibility: inject new lesson with 0 lines of UI code',
        () async {
      await engine.initialize();
      final initialCount = (await engine.getLessons()).length;

      const newLesson = Lesson(
        id: 'lesson_99',
        title: 'New Solar Power Monster Module',
        summary: 'Added purely through data without modifying UI code!',
        tier: DifficultyTier.builder,
        estimatedMinutes: 20,
        prerequisites: ['lesson_01'],
        componentIds: [],
        steps: [
          LessonStep(
            stepId: 's1',
            title: 'Solar Energy',
            type: StepType.story,
            markdownContent:
                'Photovoltaic cells convert sunlight directly into electricity!',
          ),
        ],
        xpReward: 85,
      );

      // Injected directly into the engine
      engine.injectLesson(newLesson);

      final updatedLessons = await engine.getLessons();
      expect(updatedLessons.length, equals(initialCount + 1));

      final retrieved = await engine.getLessonById('lesson_99');
      expect(retrieved.title, equals('New Solar Power Monster Module'));
      expect(retrieved.xpReward, equals(85));
    });

    test('dynamic injection validates and rejects malformed lesson data',
        () async {
      await engine.initialize();

      const invalidLesson = Lesson(
        id: 'bad_id_syntax',
        title: 'X',
        summary: '',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 2,
        prerequisites: [],
        componentIds: [],
        steps: [],
        xpReward: 0,
      );

      expect(
        () => engine.injectLesson(invalidLesson),
        throwsA(isA<CurriculumValidationException>()),
      );
    });
  });
}
