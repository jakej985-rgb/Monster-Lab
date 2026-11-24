import 'dart:async';
import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class MissingLibraryTroubleshootingWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const MissingLibraryTroubleshootingWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<MissingLibraryTroubleshootingWidget> createState() =>
      _MissingLibraryTroubleshootingWidgetState();
}

class _MissingLibraryTroubleshootingWidgetState
    extends State<MissingLibraryTroubleshootingWidget> {
  bool _isFixing = false;
  bool _isResolved = false;
  int _diagnosticStep =
      0; // 0: initial error, 1: installing, 2: compiling, 3: success
  Timer? _fixTimer;

  @override
  void dispose() {
    _fixTimer?.cancel();
    super.dispose();
  }

  void _applyFix() {
    if (_isFixing || _isResolved) return;

    setState(() {
      _isFixing = true;
      _diagnosticStep = 1;
    });

    _fixTimer?.cancel();
    _fixTimer = Timer(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _diagnosticStep = 2; // Compiling
      });

      _fixTimer = Timer(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        setState(() {
          _diagnosticStep = 3;
          _isFixing = false;
          _isResolved = true;
        });
        widget.onComplete?.call();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Compilation Error Triage: Missing Library Header';

    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _isResolved ? AppColors.success : AppColors.danger,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _isResolved
                      ? AppColors.success.withValues(alpha: 0.2)
                      : AppColors.danger.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isResolved ? AppColors.success : AppColors.danger,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isResolved ? Icons.check_circle : Icons.error,
                      color: _isResolved ? AppColors.success : AppColors.danger,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isResolved ? 'ERROR RESOLVED' : 'BUILD FAILED',
                      style: TextStyle(
                        color:
                            _isResolved ? AppColors.success : AppColors.danger,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'A fellow robotics student hit a fatal compiler error when verifying their sketch. Read the compiler console, diagnose the root cause, and apply the fix.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Red Compiler Error Console
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isResolved ? AppColors.success : AppColors.danger,
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Arduino IDE Output Console',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _isResolved
                            ? AppColors.success.withValues(alpha: 0.2)
                            : AppColors.danger.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _isResolved ? 'Exit Status: 0' : 'Exit Status: 1',
                        style: TextStyle(
                          color: _isResolved
                              ? AppColors.success
                              : AppColors.danger,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, height: 16),
                if (!_isResolved && _diagnosticStep == 0) ...[
                  const Text(
                    'sketch.ino:1:10: fatal error: LiquidCrystal_I2C.h: No such file or directory',
                    style: TextStyle(
                      color: AppColors.danger,
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    ' #include <LiquidCrystal_I2C.h>\n          ^~~~~~~~~~~~~~~~~~~~~\ncompilation terminated.',
                    style: TextStyle(
                      color: Color(0xFFFF7675),
                      fontFamily: 'monospace',
                      fontSize: 11,
                    ),
                  ),
                ] else if (_diagnosticStep == 1) ...[
                  const Text(
                    '[1/2] Connecting to Arduino Library Manager...\n[+] Downloading LiquidCrystal_I2C into ~/Arduino/libraries/\n[+] Extracted LiquidCrystal_I2C.h & LiquidCrystal_I2C.cpp',
                    style: TextStyle(
                      color: AppColors.accentCyan,
                      fontFamily: 'monospace',
                      fontSize: 11,
                    ),
                  ),
                ] else if (_diagnosticStep == 2) ...[
                  const Text(
                    '[2/2] Re-running avr-g++ compilation...\n[*] Resolving #include <LiquidCrystal_I2C.h> -> Found!\n[*] Generating AVR machine hex binary...',
                    style: TextStyle(
                      color: AppColors.energyAmber,
                      fontFamily: 'monospace',
                      fontSize: 11,
                    ),
                  ),
                ] else ...[
                  const Text(
                    'Sketch uses 3,428 bytes (10%) of program storage space. Maximum is 32,256 bytes.\nGlobal variables use 256 bytes (12%) of dynamic memory.\n[SUCCESS] Compilation finished successfully. Ready to Upload!',
                    style: TextStyle(
                      color: AppColors.success,
                      fontFamily: 'monospace',
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Diagnostic Analysis Cards
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '3-Step Diagnostic Checklist:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                _buildChecklistRow(
                  num: '1',
                  label:
                      'Check spelling and case (.h and exact capitalization)',
                  status: 'Verified (Spelling matches)',
                ),
                _buildChecklistRow(
                  num: '2',
                  label: 'Verify library is installed in ~/Arduino/libraries/',
                  status: _isResolved
                      ? 'Resolved (Installed)'
                      : 'MISSING: Not in library folder',
                  isWarning: !_isResolved,
                ),
                _buildChecklistRow(
                  num: '3',
                  label: 'Pre-compile and link header definitions',
                  status: _isResolved ? 'Clean build' : 'Blocked by Step 2',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Action Button
          ElevatedButton.icon(
            key: const Key('fix_missing_library_button'),
            onPressed: _isFixing || _isResolved ? null : _applyFix,
            icon: _isFixing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(_isResolved ? Icons.check : Icons.build_circle),
            label: Text(
              _isResolved
                  ? 'LIBRARY INSTALLED & VERIFIED'
                  : (_isFixing
                      ? 'INSTALLING & RECOMPILING...'
                      : 'INSTALL MISSING LIBRARY VIA LIBRARY MANAGER'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isResolved
                  ? const Color(0xFF007A60)
                  : AppColors.primaryViolet,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistRow({
    required String num,
    required String label,
    required String status,
    bool isWarning = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isWarning ? AppColors.danger : AppColors.accentCyan,
            ),
            alignment: Alignment.center,
            child: Text(
              num,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: isWarning
                        ? AppColors.danger
                        : (_isResolved
                            ? AppColors.success
                            : AppColors.accentCyan),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
