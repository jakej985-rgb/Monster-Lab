import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/asset_curriculum_datasource.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/data/repositories/curriculum_repository_impl.dart';
import 'package:monster_lab/domain/models/lesson_model.dart';
import 'package:monster_lab/presentation/features/learn/lesson_detail_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _pumpLessonFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 100));
}

class _CountingCurriculumRepository extends CurriculumRepositoryImpl {
  _CountingCurriculumRepository(super.engine);

  int lessonFetches = 0;

  @override
  Future<Lesson> getLessonById(String id) {
    lessonFetches++;
    return super.getLessonById(id);
  }
}

void main() {
  late CurriculumDataEngine engine;

  setUpAll(() async {
    engine =
        CurriculumDataEngine(fallbackDataSource: AssetCurriculumDataSource());
    await engine.initialize();
  });

  testWidgets('LessonDetailScreen fetches the lesson once across rebuilds',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storageService = await StorageService.init();
    final repository = _CountingCurriculumRepository(engine);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          curriculumRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(
          home: LessonDetailScreen(lessonId: 'l01_01'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(repository.lessonFetches, equals(1),
        reason: 'The initial frame should fetch the lesson once.');

    await tester.ensureVisible(find.text('Next Step'));
    await tester.tap(find.text('Next Step'));
    await tester.pumpAndSettle();

    expect(find.text('Step 2 of 4'), findsOneWidget,
        reason: 'The tap should advance to the next step.');
    expect(repository.lessonFetches, equals(1),
        reason: 'Step navigation should reuse the loaded lesson.');
  });

  testWidgets('switching lessons resets the step and quiz state',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storageService = await StorageService.init();
    final repository = CurriculumRepositoryImpl(engine);

    var lessonId = 'l01_01';
    late StateSetter rebuild;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          curriculumRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return LessonDetailScreen(lessonId: lessonId);
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Next Step'));
    await tester.tap(find.text('Next Step'));
    await tester.pumpAndSettle();
    expect(find.text('Step 2 of 4'), findsOneWidget);

    // l01_18 has only one step. The previous lesson was on step two, so this
    // would throw a RangeError if the step index were not reset.
    lessonId = 'l01_18';
    rebuild(() {});
    await _pumpLessonFrames(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Step 1 of 1'), findsOneWidget);
  });

  testWidgets('reloads the lesson when the repository provider changes',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storageService = await StorageService.init();
    final firstRepository = _CountingCurriculumRepository(engine);
    final secondRepository = _CountingCurriculumRepository(engine);
    final repositoryRevision = StateProvider<int>((ref) => 0);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          curriculumRepositoryProvider.overrideWith((ref) {
            final revision = ref.watch(repositoryRevision);
            return revision == 0 ? firstRepository : secondRepository;
          }),
        ],
        child: const MaterialApp(
          home: LessonDetailScreen(lessonId: 'l01_01'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(firstRepository.lessonFetches, equals(1));
    expect(secondRepository.lessonFetches, equals(0));

    final container = ProviderScope.containerOf(
      tester.element(find.byType(LessonDetailScreen)),
    );
    container.read(repositoryRevision.notifier).state = 1;
    await _pumpLessonFrames(tester);

    expect(firstRepository.lessonFetches, equals(1));
    expect(secondRepository.lessonFetches, equals(1));
    expect(find.text('Step 1 of 4'), findsOneWidget);
  });
}
