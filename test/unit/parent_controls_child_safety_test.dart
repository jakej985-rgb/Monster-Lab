import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/routing/app_router.dart';
import 'package:monster_lab/core/routing/route_constants.dart';
import 'package:monster_lab/core/services/component_restriction_service.dart';
import 'package:monster_lab/core/services/parent_data_service.dart';
import 'package:monster_lab/core/services/parent_session_service.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/domain/models/component_model.dart';
import 'package:monster_lab/domain/models/learner_profile_model.dart';
import 'package:monster_lab/domain/models/learner_progress_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Parent Controls & Child Safety Suite (Issues #30-#35)', () {
    late ParentSessionService sessionService;

    setUp(() {
      sessionService = ParentSessionService(
        defaultDuration: const Duration(milliseconds: 200),
      );
    });

    tearDown(() {
      sessionService.dispose();
    });

    // --- Issue #30: Expiring Parent Authorization Sessions ---
    group('Issue #30: Expiring Parent Authorization Sessions', () {
      test('authenticates and creates valid expiring session', () {
        expect(sessionService.isAuthorized, isFalse);
        expect(sessionService.currentSession, isNull);

        final session = sessionService.authenticate(
          duration: const Duration(minutes: 10),
        );

        expect(session.isValid, isTrue);
        expect(session.isExpired, isFalse);
        expect(sessionService.isAuthorized, isTrue);
        expect(session.remainingDuration.inMinutes, greaterThanOrEqualTo(9));
      });

      test('session automatically expires after configured duration', () async {
        sessionService.authenticate(duration: const Duration(milliseconds: 50));
        expect(sessionService.isAuthorized, isTrue);

        await Future<void>.delayed(const Duration(milliseconds: 80));

        expect(sessionService.isAuthorized, isFalse);
        expect(sessionService.currentSession?.isExpired, isTrue);

        expect(
          () => sessionService.executeWithAuthorization(() => 'secret_action'),
          throwsA(isA<ParentSessionExpiredException>()),
        );
      });

      test('executeWithAuthorization rejects unauthorized access', () {
        expect(
          () => sessionService
              .executeWithAuthorization(() => 'sensitive_parent_data'),
          throwsA(isA<ParentUnauthorizedException>()),
        );
      });

      test('renewSession extends session expiry before expiration', () async {
        sessionService.authenticate(
            duration: const Duration(milliseconds: 100));
        await Future<void>.delayed(const Duration(milliseconds: 50));

        final renewed = sessionService.renewSession(
          extension: const Duration(milliseconds: 300),
        );
        expect(renewed, isTrue);

        // After initial 100ms has passed, session should still be alive due to renewal
        await Future<void>.delayed(const Duration(milliseconds: 70));
        expect(sessionService.isAuthorized, isTrue);
      });

      test('revokeSession immediately invalidates active authorization', () {
        sessionService.authenticate(duration: const Duration(minutes: 15));
        expect(sessionService.isAuthorized, isTrue);

        sessionService.revokeSession();

        expect(sessionService.isAuthorized, isFalse);
        expect(sessionService.currentSession?.isRevoked, isTrue);
        expect(
          () => sessionService.executeWithAuthorization(() => 'vault_data'),
          throwsA(isA<ParentUnauthorizedException>()),
        );
      });
    });

    // --- Issue #31: Protected Route Authorization Guards ---
    group('Issue #31: Protected Route Authorization Guards', () {
      test(
          'direct route access to /parent redirects to /parent-gate when unauthorized',
          () {
        final redirect = routeAuthorizationGuard(
          location: RoutePaths.parent,
          hasActiveProfile: true,
          sessionService: sessionService,
        );

        expect(redirect, equals(RoutePaths.parentGate));
      });

      test(
          'deep-link access to /parent/settings redirects to /parent-gate when unauthorized',
          () {
        final redirect = routeAuthorizationGuard(
          location: '/parent/settings',
          hasActiveProfile: true,
          sessionService: sessionService,
        );

        expect(redirect, equals(RoutePaths.parentGate));
      });

      test('allows access to /parent when parent session is active and valid',
          () {
        sessionService.authenticate(duration: const Duration(minutes: 15));

        final redirect = routeAuthorizationGuard(
          location: RoutePaths.parent,
          hasActiveProfile: true,
          sessionService: sessionService,
        );

        expect(redirect, isNull);
      });

      test(
          'allows public informational route /parent-about without authentication',
          () {
        final redirect = routeAuthorizationGuard(
          location: RoutePaths.parentAbout,
          hasActiveProfile: true,
          sessionService: sessionService,
        );

        expect(redirect, isNull);
      });

      test('redirects unonboarded learners to /onboarding', () {
        final redirect = routeAuthorizationGuard(
          location: RoutePaths.home,
          hasActiveProfile: false,
          sessionService: sessionService,
        );

        expect(redirect, equals(RoutePaths.onboarding));
      });
    });

    // --- Issue #32: Secure Restricted Component Unlocks ---
    group('Issue #32: Secure Restricted Component Unlocks', () {
      late ComponentRestrictionService restrictionService;
      late ComponentModel restrictedLaser;

      setUp(() {
        restrictionService = ComponentRestrictionService();
        restrictedLaser = const ComponentModel(
          id: 'comp_laser',
          peripheralNumber: 37,
          name: '650nm Red Laser Diode',
          partNumber: 'KY-008',
          category: 'actuator',
          description: 'High-intensity coherent optical emitter',
          realWorldAnalogy: 'A powerful pointer of light',
          voltage: OperatingVoltage.v5,
          pinout: [],
          projectIds: ['proj_16'],
          safety: SafetyClassification(
            level: SafetyLevel.restrictedAdultSupervision,
            hazards: ['Direct beam eye hazard', 'Requires adult supervision'],
            requiresParentUnlock: true,
          ),
        );
      });

      test('identifies restricted components accurately', () {
        expect(restrictionService.isRestricted(restrictedLaser), isTrue);
        expect(
            restrictionService.isUnlocked('comp_laser', 'learner_1'), isFalse);
      });

      test('rejects unlock attempt when parent session is unauthorized',
          () async {
        await expectLater(
          restrictionService.unlockComponent(
            component: restrictedLaser,
            learnerId: 'learner_1',
            sessionService: sessionService,
          ),
          throwsA(isA<ParentUnauthorizedException>()),
        );

        expect(
            restrictionService.isUnlocked('comp_laser', 'learner_1'), isFalse);
      });

      test('rejects unlock attempt when parent session is expired', () async {
        sessionService.authenticate(duration: const Duration(milliseconds: 20));
        await Future<void>.delayed(const Duration(milliseconds: 30));

        await expectLater(
          restrictionService.unlockComponent(
            component: restrictedLaser,
            learnerId: 'learner_1',
            sessionService: sessionService,
          ),
          throwsA(isA<ParentUnauthorizedException>()),
        );

        expect(
            restrictionService.isUnlocked('comp_laser', 'learner_1'), isFalse);
      });

      test('allows unlock when parent session is active and revokes on demand',
          () async {
        sessionService.authenticate(duration: const Duration(minutes: 10));

        final ok = await restrictionService.unlockComponent(
          component: restrictedLaser,
          learnerId: 'learner_1',
          sessionService: sessionService,
        );

        expect(ok, isTrue);
        expect(
            restrictionService.isUnlocked('comp_laser', 'learner_1'), isTrue);

        // Revoke unlock
        await restrictionService.revokeUnlock('comp_laser', 'learner_1');
        expect(
            restrictionService.isUnlocked('comp_laser', 'learner_1'), isFalse);
      });

      test('persists safety authorizations across service instances', () async {
        SharedPreferences.setMockInitialValues({});
        final storage = await StorageService.init();
        final first = ComponentRestrictionService(null, storage);

        expect(first.isSafetyAuthorized('laser'), isFalse);
        await first.setSafetyAuthorized('laser', true);

        final reloaded = ComponentRestrictionService(null, storage);
        expect(reloaded.isSafetyAuthorized('laser'), isTrue);
      });

      test('persists component unlocks across service instances using storage',
          () async {
        SharedPreferences.setMockInitialValues({});
        final storage = await StorageService.init();
        final first = ComponentRestrictionService(null, storage);
        sessionService.authenticate(duration: const Duration(minutes: 10));

        expect(first.isUnlocked('comp_laser', 'learner_1'), isFalse);
        await first.unlockComponent(
          component: restrictedLaser,
          learnerId: 'learner_1',
          sessionService: sessionService,
        );
        expect(first.isUnlocked('comp_laser', 'learner_1'), isTrue);

        final reloaded = ComponentRestrictionService(null, storage);
        expect(reloaded.isUnlocked('comp_laser', 'learner_1'), isTrue);

        await reloaded.revokeUnlock('comp_laser', 'learner_1');
        expect(reloaded.isUnlocked('comp_laser', 'learner_1'), isFalse);

        final afterRevoke = ComponentRestrictionService(null, storage);
        expect(afterRevoke.isUnlocked('comp_laser', 'learner_1'), isFalse);
      });
    });

    // --- Issue #33: Destructive Action Confirmation and Rollback Recovery ---
    group('Issue #33: Destructive Action Confirmation & Rollback Recovery', () {
      late LocalStorageDataSource storage;

      setUp(() async {
        SharedPreferences.setMockInitialValues({});
        final service = await StorageService.init();
        storage = LocalStorageDataSource(service);
      });

      test('aborts destructive action when confirmation input does not match',
          () async {
        bool actionRan = false;

        await expectLater(
          ParentDataService.executeDestructiveAction(
            storageDataSource: storage,
            confirmationInput: 'CANCEL',
            requiredPhrase: 'CONFIRM',
            action: () async {
              actionRan = true;
            },
          ),
          throwsA(isA<FormatException>()),
        );

        expect(actionRan, isFalse);
      });

      test('executes destructive action cleanly when confirmation matches',
          () async {
        bool actionRan = false;

        final result = await ParentDataService.executeDestructiveAction(
          storageDataSource: storage,
          confirmationInput: 'confirm',
          requiredPhrase: 'CONFIRM',
          action: () async {
            actionRan = true;
            return 'action_completed';
          },
        );

        expect(result, equals('action_completed'));
        expect(actionRan, isTrue);
      });

      test(
          'automatically rolls back to snapshot if destructive operation encounters error',
          () async {
        // 1. Establish initial learner data
        final profile = LearnerProfileModel(
          id: 'child_safety_rollback',
          nickname: 'Bolt',
          avatarId: 'avatar_bolt',
          ageBracket: AgeBracket.ages7_9,
          createdAt: DateTime.now(),
          lastActiveAt: DateTime.now(),
        );
        final progress = LearnerProgressModel(
          learnerId: 'child_safety_rollback',
          totalXp: 500,
          completedLessonIds: {'l01_01', 'l01_02'},
          lastSessionDate: DateTime.now(),
        );

        await storage.saveProfiles([profile]);
        await storage.saveProgress(progress);

        // 2. Execute destructive action that mutates state and then throws
        await expectLater(
          ParentDataService.executeDestructiveAction(
            storageDataSource: storage,
            confirmationInput: 'CONFIRM',
            action: () async {
              // Delete profiles mid-transaction
              await storage.saveProfiles([]);
              await storage.deleteProgress('child_safety_rollback');

              // Simulate downstream I/O or network crash
              throw StateError('Simulated disk I/O failure during purge');
            },
          ),
          throwsA(isA<StateError>()),
        );

        // 3. Verify original state was completely restored from pre-destructive snapshot!
        final restoredProfiles = storage.getProfiles();
        final restoredProgress = storage.getProgress('child_safety_rollback');

        expect(restoredProfiles.length, equals(1));
        expect(restoredProfiles.first.nickname, equals('Bolt'));
        expect(restoredProgress.totalXp, equals(500));
        expect(restoredProgress.completedLessonIds, contains('l01_01'));
      });
    });

    // --- Issue #34 & #35: Child Safety, Privacy & COPPA/FERPA Review Documentation ---
    group(
        'Issue #34 & #35: Privacy Audit & Regulatory Compliance Documentation',
        () {
      test(
          'CHILD_SAFETY_AND_PRIVACY_AUDIT.md exists and contains compliance evidence matrix',
          () {
        final auditFile = File('docs/CHILD_SAFETY_AND_PRIVACY_AUDIT.md');
        expect(auditFile.existsSync(), isTrue);

        final content = auditFile.readAsStringSync();
        expect(content, contains('COPPA'));
        expect(content, contains('FERPA'));
        expect(content, contains('Zero External Telemetry'));
        expect(content, contains('100% Offline Functional Guarantee'));
        expect(content, contains('Data Inventory'));
        expect(content, contains('Permissions Inventory'));
        expect(content, contains('Pre-Destructive Snapshot Protection'));
      });
    });
  });
}
