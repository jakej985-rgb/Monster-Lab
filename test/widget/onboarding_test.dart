import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/app.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/presentation/shared/providers.dart';

void main() {
  group('First-Start Onboarding Flow Widget Tests', () {
    testWidgets('Fresh launch without active profile redirects to Onboarding',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storageService = await StorageService.init();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storageService),
          ],
          child: const MonsterLabApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Should be on Onboarding screen
      expect(find.text('Welcome to Monster Lab!'), findsOneWidget);
      expect(find.text('Welcome, Young Inventor!'), findsOneWidget);
      expect(
          find.byKey(const Key('onboarding_nickname_input')), findsOneWidget);
      expect(find.byKey(const Key('onboarding_start_button')), findsOneWidget);
    });

    testWidgets('Validation prevents submission with invalid nickname',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storageService = await StorageService.init();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storageService),
          ],
          child: const MonsterLabApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Tap start without entering nickname
      await tester
          .ensureVisible(find.byKey(const Key('onboarding_start_button')));
      await tester.tap(find.byKey(const Key('onboarding_start_button')));
      await tester.pumpAndSettle();

      expect(
          find.text('Nickname must be at least 2 characters'), findsOneWidget);

      // Enter 1 character
      await tester.enterText(
          find.byKey(const Key('onboarding_nickname_input')), 'A');
      await tester
          .ensureVisible(find.byKey(const Key('onboarding_start_button')));
      await tester.tap(find.byKey(const Key('onboarding_start_button')));
      await tester.pumpAndSettle();

      expect(
          find.text('Nickname must be at least 2 characters'), findsOneWidget);
    });

    testWidgets(
        'Completing onboarding creates active profile and navigates to Home',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storageService = await StorageService.init();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storageService),
          ],
          child: const MonsterLabApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Enter valid nickname
      await tester.enterText(
          find.byKey(const Key('onboarding_nickname_input')), 'CircuitKid');
      await tester.pumpAndSettle();

      // Select avatar (e.g. monster_gear)
      await tester.tap(find.byKey(const Key('onboarding_avatar_monster_gear')));
      await tester.pumpAndSettle();

      // Select age bracket
      await tester
          .ensureVisible(find.byKey(const Key('onboarding_age_dropdown')));
      await tester.tap(find.byKey(const Key('onboarding_age_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ages 13+ (Master Engineer)').last);
      await tester.pumpAndSettle();

      // Tap Start Your Adventure!
      await tester
          .ensureVisible(find.byKey(const Key('onboarding_start_button')));
      await tester.tap(find.byKey(const Key('onboarding_start_button')));
      await tester.pumpAndSettle();

      // Should now be on Home screen
      expect(find.textContaining('CircuitKid'), findsWidgets);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Learn'), findsOneWidget);
      expect(find.text('Parts Lab'), findsOneWidget);

      // Verify profile was persisted
      final activeId =
          storageService.getString('monster_lab_active_profile_id');
      expect(activeId, isNotNull);
      expect(activeId, isNotEmpty);
    });

    testWidgets(
        'Launch with existing active profile redirects to Home, preventing Onboarding',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'monster_lab_active_profile_id': 'child_existing',
        'monster_lab_profiles':
            '[{"id":"child_existing","nickname":"ExistingBot","avatarId":"monster_spark","ageBracket":"ages10_12","createdAt":"2026-01-01T00:00:00.000Z","lastActiveAt":"2026-01-01T00:00:00.000Z","settings":{}}]',
      });
      final storageService = await StorageService.init();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storageService),
          ],
          child: const MonsterLabApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Should be directly on Home screen, NOT Onboarding
      expect(find.text('Welcome to Monster Lab!'), findsNothing);
      expect(find.textContaining('ExistingBot'), findsWidgets);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets(
        'Rapidly tapping Start button does not create duplicate profiles',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storageService = await StorageService.init();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storageService),
          ],
          child: const MonsterLabApp(),
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('onboarding_nickname_input')), 'FastTapper');
      await tester.pumpAndSettle();

      final buttonFinder = find.byKey(const Key('onboarding_start_button'));
      await tester.ensureVisible(buttonFinder);

      // Simulate rapid tapping twice
      await tester.tap(buttonFinder);
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      // Ensure navigated to Home
      expect(find.textContaining('FastTapper'), findsWidgets);

      // Check profile count in storage
      final raw = storageService.getString('monster_lab_profiles');
      expect(raw, isNotNull);
      expect(raw, contains('FastTapper'));
      // Verify exactly 1 profile was stored
      final list = jsonDecode(raw!) as List;
      expect(list.length, equals(1));
    });
  });
}
