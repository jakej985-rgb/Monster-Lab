import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/domain/models/avatar_model.dart';
import 'package:monster_lab/presentation/shared/widgets/avatar_choice_tile.dart';
import 'package:monster_lab/presentation/shared/widgets/gtk_about_dialog.dart';

void main() {
  testWidgets(
    'AvatarChoiceTile is keyboard activatable and announces selection',
    (tester) async {
      final handle = tester.ensureSemantics();
      String? chosenAvatarId;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AvatarChoiceTile(
                key: const Key('spark_avatar'),
                avatar: MonsterAvatar.all.first,
                isSelected: true,
                onTap: () => chosenAvatarId = MonsterAvatar.all.first.id,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final semantics = tester.getSemantics(
        find.byKey(const Key('spark_avatar')),
      );
      expect(
        semantics,
        isSemantics(
          label: 'Spark robot companion',
          isButton: true,
          isSelected: true,
          hasTapAction: true,
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(chosenAvatarId, 'monster_spark');
      handle.dispose();
    },
  );

  testWidgets('About dialog remains usable at 200% text scale', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(2.0)),
          child: child!,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => GtkAboutDialog.show(context),
                child: const Text('Open About'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open About'));
    await tester.pumpAndSettle();

    expect(find.byType(GtkAboutDialog), findsOneWidget);
    expect(find.text('Copy website'), findsOneWidget);
    expect(find.text('Copy GitHub'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
    expect(find.textContaining('Environment:'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
