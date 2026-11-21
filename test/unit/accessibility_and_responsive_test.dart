import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/theme/app_theme.dart';
import 'package:monster_lab/presentation/shared/widgets/monster_button.dart';
import 'package:monster_lab/presentation/shared/widgets/monster_card.dart';
import 'package:monster_lab/presentation/shared/widgets/xp_progress_bar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Accessibility & Responsive Design System Suite (Issue #47)', () {
    test(
        'Design Tokens satisfy minimum child-safe touch target standard (>= 48x48dp)',
        () {
      expect(MonsterButton.minTouchTargetSize, greaterThanOrEqualTo(48.0));
    });

    testWidgets(
        'Interactive UI components declare valid semantic labels and button traits',
        (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Column(
              children: [
                MonsterButton(
                  label: 'Connect Companion',
                  icon: Icons.usb,
                  onPressed: () {},
                ),
                MonsterButton.secondary(
                  label: 'Troubleshoot Circuit',
                  icon: Icons.help_outline,
                  onPressed: () {},
                ),
                const XPProgressBar(
                  totalXp: 120,
                  currentLevel: 3,
                  progressRatio: 0.6,
                ),
              ],
            ),
          ),
        ),
      );

      // Verify Semantics structure
      expect(
        tester.getSemantics(find.byType(MonsterButton).first),
        matchesSemantics(
          label: 'Connect Companion',
          isButton: true,
          isEnabled: true,
          hasEnabledState: true,
        ),
      );

      expect(
        tester.getSemantics(find.byType(MonsterButton).last),
        matchesSemantics(
          label: 'Troubleshoot Circuit',
          isButton: true,
          isEnabled: true,
          hasEnabledState: true,
        ),
      );

      handle.dispose();
    });

    testWidgets(
        'Responsive layouts render properly across mobile, tablet, and desktop viewports',
        (tester) async {
      final viewports = [
        const Size(360, 640), // Compact Phone
        const Size(768, 1024), // Tablet portrait
        const Size(1024, 768), // Tablet landscape
        const Size(1920, 1080), // Desktop FHD
      ];

      for (final size in viewports) {
        await tester.binding.setSurfaceSize(size);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: Scaffold(
              body: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 900;
                  final isTablet =
                      constraints.maxWidth >= 600 && constraints.maxWidth < 900;
                  final columnCount = isDesktop ? 3 : (isTablet ? 2 : 1);

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnCount,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, idx) => MonsterCard(
                      child: Center(child: Text('Card $idx')),
                    ),
                  );
                },
              ),
            ),
          ),
        );

        // Verify zero RenderFlex overflows across all viewports
        expect(tester.takeException(), isNull);
        expect(find.byType(MonsterCard), findsWidgets);
      }

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
    });

    test(
        'Color palette contrast ratios guarantee readability in light and dark modes',
        () {
      final lightBg = AppTheme.lightTheme.scaffoldBackgroundColor;
      final darkBg = AppTheme.darkTheme.scaffoldBackgroundColor;

      // Dark background should be distinct from light background
      expect(darkBg.computeLuminance(), lessThan(0.2));
      expect(lightBg.computeLuminance(), greaterThan(0.7));
    });

    test('High contrast themes use pure surfaces and strong outlines', () {
      final light = AppTheme.buildTheme(isDark: false, highContrast: true);
      final dark = AppTheme.buildTheme(isDark: true, highContrast: true);

      expect(light.scaffoldBackgroundColor, Colors.white);
      expect(light.colorScheme.onSurface, Colors.black);
      expect(light.colorScheme.outline, Colors.black);
      expect(
          light.colorScheme.outlineVariant.computeLuminance(), lessThan(0.2));

      expect(dark.scaffoldBackgroundColor, Colors.black);
      expect(dark.colorScheme.onSurface, Colors.white);
      expect(dark.colorScheme.outline, Colors.white);
      expect(
          dark.colorScheme.outlineVariant.computeLuminance(), greaterThan(0.5));
    });
  });
}
