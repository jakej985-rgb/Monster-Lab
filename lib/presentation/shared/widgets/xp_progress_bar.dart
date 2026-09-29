import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class XPProgressBar extends StatelessWidget {
  final int totalXp;
  final int currentLevel;
  final double progressRatio;

  const XPProgressBar({
    super.key,
    required this.totalXp,
    required this.currentLevel,
    required this.progressRatio,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (progressRatio * 100).toInt().clamp(0, 100);
    return Semantics(
      container: true,
      label:
          'Level $currentLevel, $totalXp XP earned, $percent percent progress to next level',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [
            BoxShadow(
              color: Color(0x146C5CE7),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryViolet,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Lv. $currentLevel',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: SizedBox(
                  height: 12,
                  child: LinearProgressIndicator(
                    value: progressRatio,
                    semanticsLabel: 'Level progress',
                    backgroundColor: AppColors.surfaceContainerLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.energyAmber),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$totalXp XP',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
