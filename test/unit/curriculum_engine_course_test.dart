import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';

class LocalDiskAssetBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final file = File(key);
    if (!file.existsSync()) {
      throw Exception('Asset file not found on local disk: $key');
    }
    return file.readAsString();
  }

  @override
  Future<ByteData> load(String key) async {
    final file = File(key);
    if (!file.existsSync()) {
      throw Exception('Asset file not found on local disk: $key');
    }
    final bytes = await file.readAsBytes();
    return ByteData.view(bytes.buffer);
  }
}

void main() {
  group('CurriculumDataEngine Course & Lesson Queries', () {
    late CurriculumDataEngine engine;

    setUp(() async {
      engine = CurriculumDataEngine(assetBundle: LocalDiskAssetBundle());
      await engine.initialize();
    });

    test('Loads all 10 courses from disk assets', () async {
      final courses = await engine.getCourses();
      expect(courses.length, equals(10));

      final courseIds = courses.map((c) => c.id).toSet();
      expect(
          courseIds,
          containsAll([
            'lesson_01',
            'coding_foundations',
            'lesson_2a',
            'lesson_2b',
            'lesson_03',
            'lesson_04',
            'lesson_05',
            'lesson_06',
            'lesson_07',
            'lesson_08',
          ]));
    });

    test('getCourseById returns specific course', () async {
      final l01 = await engine.getCourseById('lesson_01');
      expect(l01.id, equals('lesson_01'));
      expect(l01.lessonIds.length, equals(12));

      final cf = await engine.getCourseById('coding_foundations');
      expect(cf.id, equals('coding_foundations'));
      expect(cf.isOptional, isTrue);
      expect(cf.lessonIds.length, equals(8));

      final l2a = await engine.getCourseById('lesson_2a');
      expect(l2a.id, equals('lesson_2a'));
      expect(l2a.lessonIds.length, equals(8));

      final l2b = await engine.getCourseById('lesson_2b');
      expect(l2b.id, equals('lesson_2b'));
      expect(l2b.lessonIds.length, equals(8));

      final l03 = await engine.getCourseById('lesson_03');
      expect(l03.id, equals('lesson_03'));
      expect(l03.lessonIds.length, equals(9));
    });

    test('getCourseLessons returns ordered sub-lessons for a course', () async {
      final cfLessons = await engine.getCourseLessons('coding_foundations');
      expect(cfLessons.length, equals(8));
      expect(cfLessons.first.id, equals('cf_01'));
      expect(cfLessons.last.id, equals('cf_08'));

      final l2aLessons = await engine.getCourseLessons('lesson_2a');
      expect(l2aLessons.length, equals(8));
      expect(l2aLessons.first.id, equals('l2a_01'));
      expect(l2aLessons.last.id, equals('l2a_08'));

      final l2bLessons = await engine.getCourseLessons('lesson_2b');
      expect(l2bLessons.length, equals(8));
      expect(l2bLessons.first.id, equals('l2b_01'));
      expect(l2bLessons.last.id, equals('l2b_08'));
    });
  });
}
