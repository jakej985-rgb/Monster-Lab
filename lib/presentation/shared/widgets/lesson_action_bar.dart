import 'package:material_ui/material_ui.dart';
import 'monster_button.dart';

/// A bottom action bar for lesson navigation that respects Android system insets.
/// Ensures the Next Step button is never covered by gesture nav or 3-button nav.
class LessonActionBar extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool enabled;

  const LessonActionBar({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: MonsterButton(
          label: label,
          icon: icon,
          onPressed: enabled ? onPressed : null,
        ),
      ),
    );
  }
}
