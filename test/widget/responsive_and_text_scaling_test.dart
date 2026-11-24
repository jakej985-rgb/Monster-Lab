import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/data/datasources/asset_curriculum_datasource.dart';
import 'package:monster_lab/data/repositories/curriculum_repository_impl.dart';
import 'package:monster_lab/domain/models/circuit_wiring_model.dart';
import 'package:monster_lab/presentation/features/home/home_screen.dart';
import 'package:monster_lab/presentation/features/lab/widgets/interactive_breadboard_widget.dart';
import 'package:monster_lab/presentation/features/parts/parts_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';

void main() {
  group('Responsive Layout & Text Scaling Tests', () {
    late StorageService storageService;
    late CurriculumDataEngine engine;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storageService = await StorageService.init();
      engine =
          CurriculumDataEngine(fallbackDataSource: AssetCurriculumDataSource());
      await engine.initialize();
    });

    Widget createScaledWidget({
      required Widget child,
      required double textScaleFactor,
      Size size = const Size(390, 844),
    }) {
      return ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          curriculumRepositoryProvider
              .overrideWithValue(CurriculumRepositoryImpl(engine)),
        ],
        child: MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              size: size,
              textScaler: TextScaler.linear(textScaleFactor),
            ),
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: child,
            ),
          ),
        ),
      );
    }

    testWidgets(
        'PartsScreen renders cleanly without overflow at 1.0x, 1.5x, and 2.0x text scaling',
        (tester) async {
      // 1.0x standard font scale
      await tester.pumpWidget(
          createScaledWidget(child: const PartsScreen(), textScaleFactor: 1.0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Parts Lab'), findsOneWidget);

      // 1.5x accessibility scale
      await tester.pumpWidget(
          createScaledWidget(child: const PartsScreen(), textScaleFactor: 1.5));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Parts Lab'), findsOneWidget);

      // 2.0x large accessibility scale
      await tester.pumpWidget(
          createScaledWidget(child: const PartsScreen(), textScaleFactor: 2.0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Parts Lab'), findsOneWidget);
    });

    testWidgets(
        'HomeScreen renders cleanly without overflow at 1.5x text scaling',
        (tester) async {
      await tester.pumpWidget(
          createScaledWidget(child: const HomeScreen(), textScaleFactor: 1.5));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Monster Lab'), findsOneWidget);
    });

    testWidgets(
        'PartsScreen adapts layout between phone portrait and tablet landscape',
        (tester) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));
      // Portrait phone (390 x 844)
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(
        createScaledWidget(
          child: const PartsScreen(),
          textScaleFactor: 1.0,
          size: const Size(390, 844),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Landscape tablet (1024 x 768)
      await tester.binding.setSurfaceSize(const Size(1024, 768));
      await tester.pumpWidget(
        createScaledWidget(
          child: const PartsScreen(),
          textScaleFactor: 1.0,
          size: const Size(1024, 768),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Reset surface size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets(
        'InteractiveBreadboardWidget controls adapt when text scaling is 1.5x or 2.0x',
        (tester) async {
      await tester.pumpWidget(
        createScaledWidget(
          child: Scaffold(
            body: SingleChildScrollView(
              child: InteractiveBreadboardWidget(
                preset: CircuitPresets.blinkLed,
              ),
            ),
          ),
          textScaleFactor: 1.5,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byKey(const Key('verify_wiring_button')), findsOneWidget);
    });
  });
}
