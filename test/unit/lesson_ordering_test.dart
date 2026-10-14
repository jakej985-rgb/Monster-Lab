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
        'getLessonsOrdered returns correct sequence: L01 -> CF -> 2A -> 2B -> L06 -> L04 -> L05 -> L07 -> L03 -> L08 -> L09 -> L10 -> L11 -> L12',
        () async {
      final ordered = await engine.getLessonsOrdered();
      expect(ordered.length, equals(141));

      final orderedIds = ordered.map((l) => l.id).toList();

      // First are the 18 Lesson 1 sub-lessons
      final l01Slice = orderedIds.sublist(0, 18);
      expect(l01Slice.first, equals('l01_01'));
      expect(l01Slice.last, equals('l01_18'));

      // Next are the 8 Coding Foundations lessons
      final cfSlice = orderedIds.sublist(18, 26);
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
      final l2aSlice = orderedIds.sublist(26, 34);
      expect(l2aSlice.first, equals('l2a_01'));
      expect(l2aSlice.last, equals('l2a_08'));

      // Next are the 8 Lesson 2B sub-lessons
      final l2bSlice = orderedIds.sublist(34, 42);
      expect(l2bSlice.first, equals('l2b_01'));
      expect(l2bSlice.last, equals('l2b_08'));

      // Next are Course lesson_06 (Circuits & Breadboards) sub-lessons (11)
      final l06Slice = orderedIds.sublist(42, 53);
      expect(l06Slice.first, equals('l06_01'));
      expect(l06Slice.last, equals('l06_11'));

      // Next are Course lesson_04 (PWM & RGB LEDs) sub-lessons (10)
      final l04Slice = orderedIds.sublist(53, 63);
      expect(l04Slice.first, equals('l04_01'));
      expect(l04Slice.last, equals('l04_10'));

      // Next are Course lesson_05 (Buttons & Potentiometers) sub-lessons (16)
      final l05Slice = orderedIds.sublist(63, 79);
      expect(l05Slice.first, equals('l05_01'));
      expect(l05Slice.last, equals('l05_16'));

      // Next are Course lesson_07 (Sensors & Real World) sub-lessons (11)
      final l07Slice = orderedIds.sublist(79, 90);
      expect(l07Slice.first, equals('l07_01'));
      expect(l07Slice.last, equals('l07_11'));

      // Next are Course lesson_03 (Libraries) sub-lessons (9)
      final l03Slice = orderedIds.sublist(90, 99);
      expect(l03Slice.first, equals('l03_01'));
      expect(l03Slice.last, equals('l03_09'));

      // Next are Course lesson_08 (I2C) sub-lessons (10)
      final l08Slice = orderedIds.sublist(99, 109);
      expect(l08Slice.first, equals('l08_01'));
      expect(l08Slice.last, equals('l08_10'));

      // Next are Course lesson_09 (Advanced I2C) sub-lessons (8)
      final l09Slice = orderedIds.sublist(109, 117);
      expect(l09Slice.first, equals('l09_01'));
      expect(l09Slice.last, equals('l09_08'));

      // Next are Course lesson_10 (SPI) sub-lessons (8)
      final l10Slice = orderedIds.sublist(117, 125);
      expect(l10Slice.first, equals('l10_01'));
      expect(l10Slice.last, equals('l10_08'));

      // Next are Course lesson_11 (UART) sub-lessons (8)
      final l11Slice = orderedIds.sublist(125, 133);
      expect(l11Slice.first, equals('l11_01'));
      expect(l11Slice.last, equals('l11_08'));

      // Next are Course lesson_12 (Motors) sub-lessons (8)
      final l12Slice = orderedIds.sublist(133, 141);
      expect(l12Slice.first, equals('l12_01'));
      expect(l12Slice.last, equals('l12_08'));
    });
  });
}
