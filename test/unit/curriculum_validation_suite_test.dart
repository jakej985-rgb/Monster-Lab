import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/curriculum/curriculum_validator.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';

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

  late CurriculumDataEngine engine;

  setUpAll(() async {
    engine = CurriculumDataEngine(assetBundle: LocalDiskAssetBundle());
    await engine.initialize();
  });

  group('Curriculum Automated Validation Suite', () {
    test('All 12 lessons pass CurriculumValidator schema and pedagogical rules',
        () async {
      final lessons = await engine.getLessons();
      expect(lessons.length, equals(12));

      for (final lesson in lessons) {
        expect(
          () => CurriculumValidator.validateLesson(lesson),
          returnsNormally,
          reason: 'Lesson ${lesson.id} failed validation',
        );
      }
    });

    test(
        'All 54 components pass CurriculumValidator schema and safety requirements',
        () async {
      final components = await engine.getComponents();
      expect(components.length, equals(54));

      for (final component in components) {
        expect(
          () => CurriculumValidator.validateComponent(component),
          returnsNormally,
          reason: 'Component ${component.id} failed validation',
        );
      }
    });

    test(
        'All 20 projects pass CurriculumValidator schema and step requirements',
        () async {
      final projects = await engine.getProjects();
      expect(projects.length, equals(20));

      for (final project in projects) {
        expect(
          () => CurriculumValidator.validateProject(project),
          returnsNormally,
          reason: 'Project ${project.id} failed validation',
        );
      }
    });

    test(
        'All 24 challenges pass CurriculumValidator schema and solution validation',
        () async {
      final challenges = await engine.getChallenges();
      expect(challenges.length, equals(24));

      for (final challenge in challenges) {
        expect(
          () => CurriculumValidator.validateChallenge(challenge),
          returnsNormally,
          reason: 'Challenge ${challenge.id} failed validation',
        );
      }
    });

    test('All 20 badges pass CurriculumValidator schema', () async {
      final badges = await engine.getBadges();
      expect(badges.length, equals(20));

      for (final badge in badges) {
        expect(
          () => CurriculumValidator.validateBadge(badge),
          returnsNormally,
          reason: 'Badge ${badge.id} failed validation',
        );
      }
    });

    test(
        'CurriculumValidator.validateCurriculumIntegrity passes across all 114 curriculum items',
        () async {
      final lessons = await engine.getLessons();
      final components = await engine.getComponents();
      final projects = await engine.getProjects();
      final challenges = await engine.getChallenges();
      final badges = await engine.getBadges();

      expect(
        () => CurriculumValidator.validateCurriculumIntegrity(
          lessons: lessons,
          components: components,
          projects: projects,
          challenges: challenges,
          badges: badges,
        ),
        returnsNormally,
      );
    });
  });
}
