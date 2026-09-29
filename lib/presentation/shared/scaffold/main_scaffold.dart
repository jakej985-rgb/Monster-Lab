import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        backgroundColor: AppColors.surfaceLight,
        indicatorColor: AppColors.primaryViolet.withValues(alpha: 0.15),
        elevation: 8,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primaryViolet),
            label: AppStrings.tabHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school, color: AppColors.primaryViolet),
            label: AppStrings.tabLearn,
          ),
          NavigationDestination(
            icon: Icon(Icons.extension_outlined),
            selectedIcon: Icon(Icons.extension, color: AppColors.primaryViolet),
            label: AppStrings.tabParts,
          ),
          NavigationDestination(
            icon: Icon(Icons.precision_manufacturing_outlined),
            selectedIcon: Icon(Icons.precision_manufacturing,
                color: AppColors.primaryViolet),
            label: AppStrings.tabBuild,
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon:
                Icon(Icons.emoji_events, color: AppColors.primaryViolet),
            label: AppStrings.tabProgress,
          ),
        ],
      ),
    );
  }
}
