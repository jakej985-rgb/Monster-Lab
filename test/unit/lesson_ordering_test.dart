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

    test('getLessonsOrdered returns correct sequence: lesson_01 -> CF -> 2A -> 2B -> lesson_03..12', () async {
      final ordered = await engine.getLessonsOrdered();
      expect(ordered.length, equals(35));

      final orderedIds = ordered.map((l) => l.id).toList();

      // First is lesson_01
      expect(orderedIds.first, equals('lesson_01'));

      // Next are the 8 Coding Foundations lessons
      final cfSlice = orderedIds.sublist(1, 9);
      expect(cfSlice, equals(['cf_01', 'cf_02', 'cf_03', 'cf_04', 'cf_05', 'cf_06', 'cf_07', 'cf_08']));

      // Next are the 8 Lesson 2A sub-lessons
      final l2aSlice = orderedIds.sublist(9, 17);
      expect(l2aSlice, equals(['l2a_01', 'l2a_02', 'l2a_03', 'l2a_04', 'l2a_05', 'l2a_06', 'l2a_07', 'l2a_08']));

      // Next are the 8 Lesson 2B sub-lessons
      final l2bSlice = orderedIds.sublist(17, 25);
      expect(l2bSlice, equals(['l2b_01', 'l2b_02', 'l2b_03', 'l2b_04', 'l2b_05', 'l2b_06', 'l2b_07', 'l2b_08']));

      // Next are lesson_03 through lesson_12
      final remainingSlice = orderedIds.sublist(25);
      expect(remainingSlice, equals([
        'lesson_03', 'lesson_04', 'lesson_05', 'lesson_06',
        'lesson_07', 'lesson_08', 'lesson_09', 'lesson_10',
        'lesson_11', 'lesson_12'
      ]));
    });
  });
}
