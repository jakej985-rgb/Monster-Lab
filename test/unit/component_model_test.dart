import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/domain/models/component_model.dart';

void main() {
  group('ComponentModel JSON Serialization Tests', () {
    test('Deserializes correctly with primaryImage and detailImages', () {
      final json = {
        'id': 'comp_01',
        'peripheralNumber': 1,
        'name': 'Ultrasonic Sensor',
        'partNumber': 'HC-SR04',
        'category': 'sensor',
        'description': 'Distance sensor',
        'realWorldAnalogy': 'Bat ears',
        'voltage': 'v5',
        'pinout': [
          {
            'pinName': 'VCC',
            'type': 'power',
            'description': '5V Power',
          }
        ],
        'safety': {
          'level': 'safe',
          'hazards': <String>[],
          'requiresParentUnlock': false,
        },
        'projectIds': ['proj_01'],
        'primaryImage': 'assets/images/components/comp_01.webp',
        'detailImages': ['assets/images/components/comp_01_detail.webp'],
        'imageDescription': 'Hardware photo of Ultrasonic Sensor',
      };

      final model = ComponentModel.fromJson(json);
      expect(model.id, equals('comp_01'));
      expect(
          model.primaryImage, equals('assets/images/components/comp_01.webp'));
      expect(model.detailImages,
          equals(['assets/images/components/comp_01_detail.webp']));
      expect(model.imageDescription,
          equals('Hardware photo of Ultrasonic Sensor'));

      final serialized = model.toJson();
      expect(serialized['primaryImage'],
          equals('assets/images/components/comp_01.webp'));
      expect(serialized['detailImages'],
          equals(['assets/images/components/comp_01_detail.webp']));
      expect(serialized['imageDescription'],
          equals('Hardware photo of Ultrasonic Sensor'));
    });

    test('Deserializes backward-compatibly without image fields', () {
      final json = {
        'id': 'comp_02',
        'peripheralNumber': 2,
        'name': 'Sound Sensor',
        'partNumber': 'LM393',
        'category': 'sensor',
        'description': 'Detects sound',
        'realWorldAnalogy': 'Ears',
        'voltage': 'v5',
        'pinout': [
          {
            'pinName': 'OUT',
            'type': 'digitalOut',
            'description': 'Digital trigger',
          }
        ],
        'safety': {
          'level': 'safe',
          'hazards': <String>[],
          'requiresParentUnlock': false,
        },
        'projectIds': ['proj_02'],
      };

      final model = ComponentModel.fromJson(json);
      expect(model.id, equals('comp_02'));
      expect(model.primaryImage, isNull);
      expect(model.detailImages, isEmpty);
      expect(model.imageDescription, isNull);

      final serialized = model.toJson();
      expect(serialized.containsKey('primaryImage'), isFalse);
      expect(serialized['detailImages'], isEmpty);
      expect(serialized.containsKey('imageDescription'), isFalse);
    });
  });
}
