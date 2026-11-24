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
import 'package:monster_lab/data/repositories/progress_repository_impl.dart';
import 'package:monster_lab/domain/models/learner_profile_model.dart';
import 'package:monster_lab/presentation/features/challenges/challenge_detail_screen.dart';
import 'package:monster_lab/presentation/features/challenges/challenges_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';

void main() {
  group('Phase 10: Challenges and Quizzes Tests', () {
    late StorageService storageService;
    late CurriculumDataEngine engine;
    late ProfileRepositoryImpl profileRepo;
    late ProgressRepositoryImpl progressRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storageService = await StorageService.init();
      engine =
          CurriculumDataEngine(fallbackDataSource: AssetCurriculumDataSource());
      await engine.initialize();

      final localDataSource = LocalStorageDataSource(storageService);
      profileRepo = ProfileRepositoryImpl(localDataSource);
      progressRepo = ProgressRepositoryImpl(localDataSource);
    });

    Widget createTestWidget(Widget child,
        [List<Override> extraOverrides = const []]) {
      return ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          curriculumRepositoryProvider
              .overrideWithValue(CurriculumRepositoryImpl(engine)),
          profileRepositoryProvider.overrideWithValue(profileRepo),
          progressRepositoryProvider.overrideWithValue(progressRepo),
          ...extraOverrides,
        ],
        child: MaterialApp(
          home: child,
        ),
      );
    }

    testWidgets('ChallengesScreen renders all 24 challenges and tier filters',
        (tester) async {
      await tester.pumpWidget(createTestWidget(const ChallengesScreen()));
      await tester.pumpAndSettle();

      // Verify Header
      expect(find.text('Challenge Arena'), findsOneWidget);

      // Verify Mastery Banner
      expect(find.text('Mastery Progress'), findsOneWidget);
      expect(find.text('0 / 24 Solved'), findsOneWidget);

      // Verify Filter Chips
      expect(find.text('All Tiers'), findsOneWidget);
      expect(find.text('Rookie'), findsOneWidget);
      expect(find.text('Builder'), findsOneWidget);
      expect(find.text('Engineer'), findsOneWidget);
      expect(find.text('Monster Master'), findsOneWidget);

      // Verify initial challenges visible
      expect(find.text('Missing Ground Wire'), findsOneWidget);

      // Filter by Monster Master
      await tester.tap(find.text('Monster Master'));
      await tester.pumpAndSettle();

      expect(find.text('Missing Ground Wire'), findsNothing);
      expect(find.text('NRF24L01 Voltage Killer'), findsOneWidget);
      expect(find.text('MPU-6050 Sleep Mode Trap'), findsOneWidget);

      // Filter by Builder
      await tester.tap(find.text('Builder'));
      await tester.pumpAndSettle();

      expect(find.text('NRF24L01 Voltage Killer'), findsNothing);
      expect(find.text('I2C Bus Address Collision'), findsOneWidget);
      expect(find.text('The Ghost Button Trigger'), findsOneWidget);

      // Switch back to All Tiers
      await tester.tap(find.text('All Tiers'));
      await tester.pumpAndSettle();

      expect(find.text('Missing Ground Wire'), findsOneWidget);
    });

    testWidgets(
        'ChallengeDetailScreen displays content, wiring diagram, and options',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget(
        const ChallengeDetailScreen(challengeId: 'chal_01'),
      ));
      await tester.pumpAndSettle();

      // Verify Header and Badges
      expect(find.text('ROOKIE'), findsOneWidget);
      expect(find.text('Fix Wiring'), findsOneWidget);
      expect(find.text('+30 XP'), findsOneWidget);
      expect(find.text('Missing Ground Wire'), findsOneWidget);

      // Verify Prompt
      expect(find.textContaining('LED circuit is connected to Pin 13'),
          findsOneWidget);

      // Verify Circuit Snippet Box
      expect(find.text('WIRING DIAGRAM'), findsOneWidget);
      expect(find.textContaining('LED Anode (+) -> LED Cathode (-) -> ???'),
          findsOneWidget);

      // Verify Options
      expect(find.text('A connection to Arduino 5V'), findsOneWidget);
      expect(find.text('A connection to Arduino GND'), findsOneWidget);
      expect(find.text('A second 220Ω resistor'), findsOneWidget);
      expect(find.text('A 9V battery input'), findsOneWidget);
    });

    testWidgets(
        'ChallengeDetailScreen code snippet rendering on code change challenge',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget(
        const ChallengeDetailScreen(challengeId: 'chal_04'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Double the Blinking Speed'), findsOneWidget);
      expect(find.text('Code Modification'), findsOneWidget);
      expect(find.text('ARDUINO C++'), findsOneWidget);
      expect(find.textContaining('delay(1000)'), findsWidgets);
    });

    testWidgets('Tiered hints progression unlocks Hint 1 then Hint 2',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget(
        const ChallengeDetailScreen(challengeId: 'chal_01'),
      ));
      await tester.pumpAndSettle();

      // Initially no hint box is visible
      expect(find.text('Hint 1 (Concept):'), findsNothing);
      expect(find.text('Hint 2 (Clue):'), findsNothing);

      // Reveal Hint 1
      final hintButton = find.byKey(const Key('reveal_hint_button'));
      expect(hintButton, findsOneWidget);
      await tester.tap(hintButton);
      await tester.pumpAndSettle();

      expect(find.text('Hint 1 (Concept):'), findsOneWidget);
      expect(find.textContaining('Electricity must flow in a complete loop'),
          findsOneWidget);
      expect(find.text('Hint 2 (Clue):'), findsNothing);

      // Reveal Hint 2
      await tester.tap(hintButton);
      await tester.pumpAndSettle();

      expect(find.text('Hint 1 (Concept):'), findsOneWidget);
      expect(find.text('Hint 2 (Clue):'), findsOneWidget);
      expect(find.textContaining('Look for the common negative rail'),
          findsOneWidget);
    });

    testWidgets(
        'Incorrect answer displays retry encouragement and increments attempts',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget(
        const ChallengeDetailScreen(challengeId: 'chal_01'),
      ));
      await tester.pumpAndSettle();

      // Tap wrong option (A: 5V)
      await tester.tap(find.text('A connection to Arduino 5V'));
      await tester.pumpAndSettle();

      // Submit
      final submitButton = find.byKey(const Key('submit_answer_button'));
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify Error Feedback
      expect(find.text('Not quite! Give it another shot.'), findsOneWidget);
      expect(find.text('Attempt 1'), findsOneWidget);

      // Tap Try Again
      final tryAgainButton = find.byKey(const Key('try_again_button'));
      await tester.tap(tryAgainButton);
      await tester.pumpAndSettle();

      // Verify reset state
      expect(find.text('Not quite! Give it another shot.'), findsNothing);
    });

    testWidgets('Correct answer awards XP and reveals pedagogical explanation',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final profile = LearnerProfileModel(
        id: 'test_learner',
        nickname: 'Sparky',
        avatarId: 'monster_bolt',
        ageBracket: AgeBracket.ages10_12,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      await profileRepo.saveProfile(profile);
      await profileRepo.setActiveProfile(profile.id);

      await tester.pumpWidget(createTestWidget(
        const ChallengeDetailScreen(challengeId: 'chal_01'),
      ));
      await tester.pumpAndSettle();

      // Select correct option (B: GND)
      await tester.tap(find.text('A connection to Arduino GND'));
      await tester.pumpAndSettle();

      // Submit
      await tester.tap(find.byKey(const Key('submit_answer_button')));
      await tester.pumpAndSettle();

      // Verify Success Feedback
      expect(find.text('Outstanding! Mastered (+30 XP)'), findsOneWidget);
      expect(find.text('Why this works:'), findsOneWidget);
      expect(find.textContaining('A circuit requires a closed loop.'),
          findsOneWidget);

      // Check return button
      expect(
          find.byKey(const Key('return_to_challenges_button')), findsOneWidget);

      // Verify progress persistence
      final progress = await progressRepo.getProgress('test_learner');
      expect(progress.solvedChallengeIds.contains('chal_01'), isTrue);
      expect(progress.totalXp, 30);
    });
  });
}
