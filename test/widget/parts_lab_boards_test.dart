import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/asset_curriculum_datasource.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/data/repositories/curriculum_repository_impl.dart';
import 'package:monster_lab/data/repositories/profile_repository_impl.dart';
import 'package:monster_lab/domain/models/learner_profile_model.dart';
import 'package:monster_lab/presentation/features/parts/parts_screen.dart';
import 'package:monster_lab/presentation/features/parts/part_detail_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';

void main() {
  group('Main Boards & Expanded Kit Inventory Tests', () {
    late StorageService storageService;
    late CurriculumDataEngine engine;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storageService = await StorageService.init();
      engine =
          CurriculumDataEngine(fallbackDataSource: AssetCurriculumDataSource());
      await engine.initialize();
    });

    Widget createTestWidget(Widget child) {
      return ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          curriculumRepositoryProvider
              .overrideWithValue(CurriculumRepositoryImpl(engine)),
        ],
        child: MaterialApp(
          home: child,
        ),
      );
    }

    testWidgets(
        'Tapping Main Boards chip filters to all 5 microcontroller boards',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget(const PartsScreen()));
      await tester.pumpAndSettle();

      // Find and tap "Main Boards" ChoiceChip
      final mainBoardsChip = find.text('Main Boards');
      expect(mainBoardsChip, findsOneWidget);
      await tester.tap(mainBoardsChip);
      await tester.pumpAndSettle();

      // Verify all 5 microcontroller boards appear in filtered list
      expect(find.text('Arduino Uno R3'), findsOneWidget);
      expect(find.text('Arduino Nano V3'), findsOneWidget);
      expect(find.text('Arduino Mega 2560'), findsOneWidget);
      expect(find.text('ESP32 DevKit V1'), findsOneWidget);
      expect(find.text('ESP8266 NodeMCU V3'), findsOneWidget);

      // Verify non-board components are NOT visible in filtered list
      expect(find.text('Ultrasonic Distance Sensor'), findsNothing);
      expect(find.text('Servo Motor 9g (SG90)'), findsNothing);
    });

    testWidgets(
        'New modules, ICs, and prototyping items render correctly in PartDetailScreen',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final profileRepo =
          ProfileRepositoryImpl(LocalStorageDataSource(storageService));
      final testProfile = LearnerProfileModel(
        id: 'child_tester',
        nickname: 'Circuit',
        avatarId: 'monster_bolt',
        ageBracket: AgeBracket.ages10_12,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      await profileRepo.saveProfile(testProfile);
      await profileRepo.setActiveProfile(testProfile.id);

      // Test L293D Motor Driver IC
      await tester.pumpWidget(
        createTestWidget(const PartDetailScreen(componentId: 'comp_l293d')),
      );
      await tester.pumpAndSettle();
      expect(find.text('L293D Dual H-Bridge Motor Driver IC'), findsOneWidget);
      expect(find.text('L293D'), findsOneWidget);

      // Test ISD1820 Voice Recording Module
      await tester.pumpWidget(
        createTestWidget(const PartDetailScreen(componentId: 'comp_isd1820')),
      );
      await tester.pumpAndSettle();
      expect(find.text('ISD1820 Voice Recording & Playback Module'),
          findsOneWidget);
      expect(find.text('5V'), findsOneWidget);

      // Test 4-Digit Display
      await tester.pumpWidget(
        createTestWidget(
            const PartDetailScreen(componentId: 'comp_4digit_display')),
      );
      await tester.pumpAndSettle();
      expect(find.text('4-Digit 7-Segment LED Clock Display'), findsOneWidget);

      // Test USB Doctor
      await tester.pumpWidget(
        createTestWidget(
            const PartDetailScreen(componentId: 'comp_usb_doctor')),
      );
      await tester.pumpAndSettle();
      expect(find.text('USB Charger Doctor Multimeter'), findsOneWidget);
    });
  });
}
