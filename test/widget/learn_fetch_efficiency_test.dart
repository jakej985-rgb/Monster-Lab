import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/asset_curriculum_datasource.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/data/repositories/curriculum_repository_impl.dart';
import 'package:monster_lab/domain/models/course_model.dart';
import 'package:monster_lab/domain/models/lesson_model.dart';
import 'package:monster_lab/presentation/features/learn/learn_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';

class _CountingCurriculumRepository extends CurriculumRepositoryImpl {
  _CountingCurriculumRepository(super.engine);

  int lessonFetches = 0;
  int courseFetches = 0;

  @override
  Future<List<Lesson>> getLessons({DifficultyTier? tier}) {
    lessonFetches++;
    return super.getLessons(tier: tier);
  }

  @override
  Future<List<CourseModel>> getCourses() {
    courseFetches++;
    return super.getCourses();
  }
}

void main() {
  late CurriculumDataEngine engine;

  setUpAll(() async {
    engine =
        CurriculumDataEngine(fallbackDataSource: AssetCurriculumDataSource());
    await engine.initialize();
  });

  testWidgets('Learn catalog is cached across folder toggles and tier changes',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    SharedPreferences.setMockInitialValues({});
    final storageService = await StorageService.init();
    final repository = _CountingCurriculumRepository(engine);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          curriculumRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: LearnScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(repository.lessonFetches, equals(1));
    expect(repository.courseFetches, equals(1));

    final firstFolder = find.byKey(const Key('folder_header_lesson_01'));
    expect(firstFolder, findsOneWidget);

    // Collapsing/expanding a folder must not re-query the curriculum.
    await tester.tap(firstFolder);
    await tester.pumpAndSettle();
    expect(repository.lessonFetches, equals(1));
    expect(repository.courseFetches, equals(1));

    // A new tier legitimately loads that tier's lessons once; courses stay cached.
    await tester.tap(find.text('Rookie (Beginner)'));
    await tester.pumpAndSettle();
    expect(repository.lessonFetches, equals(2));
    expect(repository.courseFetches, equals(1));

    final rookieFolder = find.byKey(const Key('folder_header_lesson_01'));
    expect(rookieFolder, findsOneWidget);
    await tester.tap(rookieFolder);
    await tester.pumpAndSettle();
    expect(repository.lessonFetches, equals(2));
    expect(repository.courseFetches, equals(1));
  });
}
