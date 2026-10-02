import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_constants.dart';
import '../../presentation/shared/scaffold/main_scaffold.dart';
import '../../presentation/features/home/home_screen.dart';
import '../../presentation/features/learn/learn_screen.dart';
import '../../presentation/features/learn/lesson_detail_screen.dart';
import '../../presentation/features/parts/parts_screen.dart';
import '../../presentation/features/parts/part_detail_screen.dart';
import '../../presentation/features/build/build_screen.dart';
import '../../presentation/features/build/build_detail_screen.dart';
import '../../presentation/features/challenges/challenges_screen.dart';
import '../../presentation/features/challenges/challenge_detail_screen.dart';
import '../../presentation/features/progress/progress_screen.dart';
import '../../presentation/features/parent/parent_gate_dialog.dart';
import '../../presentation/features/parent/parent_screen.dart';
import '../../presentation/features/parent/about_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../presentation/features/onboarding/onboarding_screen.dart';
import '../../presentation/features/profile/profile_select_screen.dart';
import '../../presentation/features/settings/settings_screen.dart';
import '../../presentation/features/troubleshoot/troubleshooting_screen.dart';
import '../../presentation/features/hardware/hardware_companion_screen.dart';
import '../../presentation/features/lab/interactive_lab_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RoutePaths.home,
  redirect: (BuildContext context, GoRouterState state) async {
    final prefs = await SharedPreferences.getInstance();
    final activeId = prefs.getString('monster_lab_active_profile_id');
    final profilesRaw = prefs.getString('monster_lab_profiles');

    bool hasActiveProfile = false;
    if (activeId != null && activeId.trim().isNotEmpty) {
      if (profilesRaw != null && profilesRaw.isNotEmpty) {
        try {
          final list = jsonDecode(profilesRaw) as List;
          hasActiveProfile = list
              .any((item) => (item as Map<String, dynamic>)['id'] == activeId);
        } catch (_) {
          hasActiveProfile = true;
        }
      } else {
        hasActiveProfile = true;
      }
    }

    final isOnboarding = state.matchedLocation == RoutePaths.onboarding;
    if (!hasActiveProfile) {
      return isOnboarding ? null : RoutePaths.onboarding;
    }
    if (isOnboarding) {
      return RoutePaths.home;
    }
    return null;
  },
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.home,
              name: RouteNames.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Tab 2: Learn
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.learn,
              name: RouteNames.learn,
              builder: (context, state) => const LearnScreen(),
            ),
          ],
        ),
        // Tab 3: Parts
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.parts,
              name: RouteNames.parts,
              builder: (context, state) => const PartsScreen(),
            ),
          ],
        ),
        // Tab 4: Build
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.build,
              name: RouteNames.build,
              builder: (context, state) => const BuildScreen(),
            ),
          ],
        ),
        // Tab 5: Progress
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.progress,
              name: RouteNames.progress,
              builder: (context, state) => const ProgressScreen(),
            ),
          ],
        ),
      ],
    ),
    // Full screen detail & modal routes
    GoRoute(
      path: RoutePaths.onboarding,
      name: RouteNames.onboarding,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RoutePaths.profileSelect,
      name: RouteNames.profileSelect,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ProfileSelectScreen(),
    ),
    GoRoute(
      path: RoutePaths.lessonDetail,
      name: RouteNames.lessonDetail,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final lessonId = state.pathParameters['lessonId'] ?? 'lesson_01';
        return LessonDetailScreen(lessonId: lessonId);
      },
    ),
    GoRoute(
      path: RoutePaths.partDetail,
      name: RouteNames.partDetail,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final componentId = state.pathParameters['componentId'] ?? 'comp_01';
        return PartDetailScreen(componentId: componentId);
      },
    ),
    GoRoute(
      path: RoutePaths.buildDetail,
      name: RouteNames.buildDetail,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final projectId = state.pathParameters['projectId'] ?? 'proj_01';
        return BuildDetailScreen(projectId: projectId);
      },
    ),
    GoRoute(
      path: RoutePaths.challenges,
      name: RouteNames.challenges,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ChallengesScreen(),
    ),
    GoRoute(
      path: RoutePaths.challengeDetail,
      name: RouteNames.challengeDetail,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final challengeId = state.pathParameters['challengeId'] ?? 'chal_01';
        return ChallengeDetailScreen(challengeId: challengeId);
      },
    ),

    GoRoute(
      path: RoutePaths.parentGate,
      name: RouteNames.parentGate,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ParentGateDialog(),
    ),
    GoRoute(
      path: RoutePaths.parent,
      name: RouteNames.parent,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ParentScreen(),
    ),
    GoRoute(
      path: RoutePaths.parentAbout,
      name: RouteNames.parentAbout,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: RoutePaths.settings,
      name: RouteNames.settings,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: RoutePaths.troubleshoot,
      name: RouteNames.troubleshoot,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TroubleshootingScreen(),
    ),
    GoRoute(
      path: RoutePaths.hardware,
      name: RouteNames.hardware,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const HardwareCompanionScreen(),
    ),
    GoRoute(
      path: RoutePaths.interactiveLab,
      name: RouteNames.interactiveLab,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const InteractiveLabScreen(),
    ),
  ],
);
