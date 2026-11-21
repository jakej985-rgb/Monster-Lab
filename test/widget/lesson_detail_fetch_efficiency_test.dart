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
  testWidgets('LessonDetailScreen fetches the lesson once across rebuilds',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storageService = await StorageService.init();
    final engine =
        CurriculumDataEngine(fallbackDataSource: AssetCurriculumDataSource());
    await engine.initialize();
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

    expect(repository.lessonFetches, equals(1),
        reason: 'Step navigation should reuse the loaded lesson.');
  });
}
