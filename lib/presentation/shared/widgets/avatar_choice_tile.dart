import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import '../../../domain/models/avatar_model.dart';

/// A desktop-friendly avatar choice with focus, keyboard activation,
/// hover feedback, and selected-state semantics.
class AvatarChoiceTile extends StatefulWidget {
  final MonsterAvatar avatar;
  final bool isSelected;
  final double width;
  final VoidCallback onTap;

  const AvatarChoiceTile({
    super.key,
    required this.avatar,
    required this.isSelected,
    required this.onTap,
    this.width = 72,
  });

  @override
  State<AvatarChoiceTile> createState() => _AvatarChoiceTileState();
}

class _AvatarChoiceTileState extends State<AvatarChoiceTile> {
  bool _isFocused = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final avatar = widget.avatar;
    final isSelected = widget.isSelected;

    Color? tileColor;
    if (isSelected) {
      tileColor = avatar.backgroundColor;
    } else if (_isHovered) {
      tileColor = colorScheme.surfaceContainerHigh;
    } else {
      tileColor = colorScheme.surfaceContainerHighest;
    }

    final focusBorder = _isFocused
        ? colorScheme.primary
        : (isSelected ? avatar.accentColor : Colors.transparent);

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${avatar.name} robot companion',
      excludeSemantics: true,
      onTap: widget.onTap,
      child: Tooltip(
        message: '${avatar.name} robot companion',
        waitDuration: const Duration(milliseconds: 600),
        child: FocusableActionDetector(
          mouseCursor: SystemMouseCursors.click,
          onFocusChange: (focused) {
            if (_isFocused != focused) {
              setState(() => _isFocused = focused);
            }
          },
          onShowHoverHighlight: (hovered) {
            if (_isHovered != hovered) {
              setState(() => _isHovered = hovered);
            }
          },
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                widget.onTap();
                return null;
              },
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
              width: widget.width,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: tileColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: focusBorder,
                  width: 2.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: avatar.accentColor,
                    child: Icon(avatar.icon, color: Colors.white, size: 20),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    avatar.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? avatar.accentColor
                          : colorScheme.onSurfaceVariant,
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
