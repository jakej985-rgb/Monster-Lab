import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/app.dart';
import 'package:monster_lab/core/routing/app_router.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/presentation/shared/providers.dart';
import 'package:monster_lab/presentation/shared/widgets/gtk_about_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late CurriculumDataEngine engine;
  late StorageService storageService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'monster_lab_active_profile_id': 'prof_default',
      'monster_lab_profiles':
          '[{"id":"prof_default","nickname":"Tester","avatarId":"avatar_sparky","ageBracket":"ages10_12",'
              '"createdAt":"2026-01-01T00:00:00.000Z","lastActiveAt":"2026-01-01T00:00:00.000Z","settings":{}}]',
    });
    storageService = await StorageService.init();
    engine = CurriculumDataEngine();
    await engine.initialize();
  });

  testWidgets(
      'Global shortcuts (Ctrl+=, Ctrl+-, Ctrl+0, F1) operate on full-screen detail routes',
      (tester) async {
    final container = ProviderContainer(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
        curriculumDataEngineProvider.overrideWithValue(engine),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MonsterLabApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Navigate to a detail route outside MainScaffold (parentNavigatorKey: _rootNavigatorKey)
    appRouter.go('/parts/comp_01');
    await tester.pumpAndSettle();

    final initialScale = container.read(settingsNotifierProvider).uiScale;

    // Trigger Ctrl+= (zoom in)
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.equal);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();

    final zoomedInScale = container.read(settingsNotifierProvider).uiScale;
    expect(zoomedInScale, greaterThan(initialScale));

    // Trigger Ctrl+- (zoom out)
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.minus);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();

    final zoomedOutScale = container.read(settingsNotifierProvider).uiScale;
    expect(zoomedOutScale, lessThan(zoomedInScale));

    // Trigger Ctrl+0 (reset zoom)
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit0);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();

    expect(container.read(settingsNotifierProvider).uiScale, 0.0);

    // Trigger F1 (About Dialog)
    await tester.sendKeyEvent(LogicalKeyboardKey.f1);
    await tester.pumpAndSettle();

    expect(find.byType(GtkAboutDialog), findsOneWidget);
  });
}
