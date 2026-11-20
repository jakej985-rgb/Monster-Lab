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

  static const double desktopBreakpoint = 720.0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= desktopBreakpoint;

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      AppColors.primaryViolet.withValues(alpha: 0.15),
                  child: const Icon(
                    Icons.smart_toy_outlined,
                    color: AppColors.primaryViolet,
                    size: 22,
                  ),
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon:
                      Icon(Icons.home, color: AppColors.primaryViolet),
                  label: Text(AppStrings.tabHome),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.school_outlined),
                  selectedIcon:
                      Icon(Icons.school, color: AppColors.primaryViolet),
                  label: Text(AppStrings.tabLearn),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.extension_outlined),
                  selectedIcon:
                      Icon(Icons.extension, color: AppColors.primaryViolet),
                  label: Text(AppStrings.tabParts),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.precision_manufacturing_outlined),
                  selectedIcon: Icon(Icons.precision_manufacturing,
                      color: AppColors.primaryViolet),
                  label: Text(AppStrings.tabBuild),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.emoji_events_outlined),
                  selectedIcon:
                      Icon(Icons.emoji_events, color: AppColors.primaryViolet),
                  label: Text(AppStrings.tabProgress),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

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
