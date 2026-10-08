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
  group('Curriculum Lesson Ordering Tests', () {
    late CurriculumDataEngine engine;

    setUp(() async {
      engine = CurriculumDataEngine(assetBundle: LocalDiskAssetBundle());
      await engine.initialize();
    });

    test(
        'getLessonsOrdered returns correct sequence: L01 -> CF -> 2A -> 2B -> L03..L08 -> lesson_09..12',
        () async {
      final ordered = await engine.getLessonsOrdered();
      expect(ordered.length, equals(107));

      final orderedIds = ordered.map((l) => l.id).toList();

      // First are the 12 Lesson 1 sub-lessons
      final l01Slice = orderedIds.sublist(0, 12);
      expect(l01Slice.first, equals('l01_01'));
      expect(l01Slice.last, equals('l01_12'));

      // Next are the 8 Coding Foundations lessons
      final cfSlice = orderedIds.sublist(12, 20);
      expect(
          cfSlice,
          equals([
            'cf_01',
            'cf_02',
            'cf_03',
            'cf_04',
            'cf_05',
            'cf_06',
            'cf_07',
            'cf_08'
          ]));

      // Next are the 8 Lesson 2A sub-lessons
      final l2aSlice = orderedIds.sublist(20, 28);
      expect(l2aSlice.first, equals('l2a_01'));
      expect(l2aSlice.last, equals('l2a_08'));

      // Next are the 8 Lesson 2B sub-lessons
      final l2bSlice = orderedIds.sublist(28, 36);
      expect(l2bSlice.first, equals('l2b_01'));
      expect(l2bSlice.last, equals('l2b_08'));

      // Next are Lesson 3 sub-lessons (9)
      final l03Slice = orderedIds.sublist(36, 45);
      expect(l03Slice.first, equals('l03_01'));
      expect(l03Slice.last, equals('l03_09'));

      // Next are Lesson 8 sub-lessons (10)
      final l08Slice = orderedIds.sublist(93, 103);
      expect(l08Slice.first, equals('l08_01'));
      expect(l08Slice.last, equals('l08_10'));

      // Last are standalone lesson_09 through lesson_12
      final standaloneSlice = orderedIds.sublist(103);
      expect(standaloneSlice,
          equals(['lesson_09', 'lesson_10', 'lesson_11', 'lesson_12']));
    });
  });
}
