import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_metadata.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/routing/route_constants.dart';

/// Native-styled GTK desktop sidebar for Monster Lab (Cinnamon / X-Apps design).
class GtkSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const GtkSidebar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  static const double width = 210.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    const items = [
      _SidebarItemData(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: AppStrings.tabHome,
      ),
      _SidebarItemData(
        icon: Icons.school_outlined,
        selectedIcon: Icons.school,
        label: AppStrings.tabLearn,
      ),
      _SidebarItemData(
        icon: Icons.extension_outlined,
        selectedIcon: Icons.extension,
        label: AppStrings.tabParts,
      ),
      _SidebarItemData(
        icon: Icons.precision_manufacturing_outlined,
        selectedIcon: Icons.precision_manufacturing,
        label: AppStrings.tabBuild,
      ),
      _SidebarItemData(
        icon: Icons.emoji_events_outlined,
        selectedIcon: Icons.emoji_events,
        label: AppStrings.tabProgress,
      ),
    ];

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // App Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                    semanticLabel: 'Monster Lab app icon',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Monster Lab',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        appVersionLabel,
                        style: TextStyle(
                          color: theme.textTheme.bodySmall?.color
                              ?.withValues(alpha: 0.7),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: theme.colorScheme.outlineVariant,
          ),
          const SizedBox(height: 8),

          // Navigation items
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 2),
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = (index == selectedIndex);

                return _GtkSidebarRow(
                  icon: isSelected ? item.selectedIcon : item.icon,
                  label: item.label,
                  isSelected: isSelected,
                  primaryColor: primaryColor,
                  onTap: () => onDestinationSelected(index),
                );
              },
            ),
          ),

          Divider(
            height: 1,
            thickness: 1,
            color: theme.colorScheme.outlineVariant,
          ),
          const SizedBox(height: 6),

          // Footer action items (Settings & Profile switch)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: _GtkSidebarRow(
              icon: Icons.settings_outlined,
              label: 'Settings',
              isSelected: false,
              primaryColor: primaryColor,
              onTap: () => context.push(RoutePaths.settings),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItemData {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _SidebarItemData({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class _GtkSidebarRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback onTap;

  const _GtkSidebarRow({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  State<_GtkSidebarRow> createState() => _GtkSidebarRowState();
}

class _GtkSidebarRowState extends State<_GtkSidebarRow> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color? backgroundColor;
    if (widget.isSelected) {
      backgroundColor = widget.primaryColor.withValues(alpha: 0.15);
    } else if (_isHovered || _isFocused) {
      backgroundColor = isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.06);
    }

    final textColor = widget.isSelected
        ? widget.primaryColor
        : theme.colorScheme.onSurfaceVariant;

    final iconColor = widget.isSelected ? widget.primaryColor : textColor;

    return Semantics(
      button: true,
      selected: widget.isSelected,
      focused: _isFocused,
      label: widget.label,
      excludeSemantics: true,
      child: Tooltip(
        message: widget.label,
        waitDuration: const Duration(milliseconds: 600),
        child: FocusableActionDetector(
          mouseCursor: SystemMouseCursors.click,
          onFocusChange: (focused) {
            if (_isFocused != focused) {
              setState(() => _isFocused = focused);
            }
            if (focused) {
              // Reveal the row if clipped, in either scroll direction.
              Scrollable.ensureVisible(
                context,
                alignmentPolicy:
                    ScrollPositionAlignmentPolicy.keepVisibleAtStart,
              );
              Scrollable.ensureVisible(
                context,
                alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
              );
            }
          },
          onShowHoverHighlight: (hovered) {
            if (_isHovered != hovered) {
              setState(() => _isHovered = hovered);
            }
          },
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) => widget.onTap(),
            ),
          },
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          },
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              height: 36,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _isFocused ? widget.primaryColor : Colors.transparent,
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  // Left Accent indicator stripe on selection
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    width: 3,
                    height: widget.isSelected ? 20 : 0,
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? widget.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: widget.isSelected ? 8 : 4),
                  Icon(widget.icon, size: 18, color: iconColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: widget.isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
