import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class LibraryManagerSimulatorWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const LibraryManagerSimulatorWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<LibraryManagerSimulatorWidget> createState() =>
      _LibraryManagerSimulatorWidgetState();
}

class _LibraryManagerSimulatorWidgetState
    extends State<LibraryManagerSimulatorWidget> {
  final TextEditingController _searchController =
      TextEditingController(text: 'LiquidCrystal_I2C');
  bool _isInstalling = false;
  bool _isInstalled = false;
  double _installProgress = 0.0;
  String _installStatusText = '';
  Timer? _installTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _installTimer?.cancel();
    super.dispose();
  }

  void _startInstall() {
    if (_isInstalling || _isInstalled) return;

    setState(() {
      _isInstalling = true;
      _installProgress = 0.0;
      _installStatusText = 'Connecting to library registry...';
    });

    int step = 0;
    _installTimer?.cancel();
    _installTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      step++;
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _installProgress = (step / 5).clamp(0.0, 1.0);
        if (step == 1) {
          _installStatusText = 'Downloading LiquidCrystal_I2C v1.1.2...';
        } else if (step == 2) {
          _installStatusText = 'Extracting headers and source files...';
        } else if (step == 3) {
          _installStatusText = 'Resolving dependency: Wire.h (Built-in I2C)...';
        } else if (step == 4) {
          _installStatusText = 'Indexing library into Arduino IDE...';
        } else if (step >= 5) {
          timer.cancel();
          _isInstalling = false;
          _isInstalled = true;
          _installStatusText = 'Installation Complete!';
          widget.onComplete?.call();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Virtual Library Manager: Search & Install';

    final query = _searchController.text.trim().toLowerCase();
    final matchesQuery = query.isEmpty ||
        query.contains('liquid') ||
        query.contains('crystal') ||
        query.contains('i2c') ||
        query.contains('lcd');

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
                    color: AppColors.accentCyan,
                  ),
                ),
              ),
              if (_isInstalled)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.success),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle,
                          color: AppColors.success, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'INSTALLED',
                        style: TextStyle(
                          color: AppColors.success,
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
            'The Arduino IDE Library Manager lets you search open-source repositories and install community drivers with one click.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // IDE Window Simulation Container
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Window Header
                const Row(
                  children: [
                    Icon(Icons.folder_special,
                        color: AppColors.accentCyan, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Tools > Manage Libraries... (Library Manager)',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Search Bar
                TextField(
                  key: const Key('library_search_input'),
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Filter your search (e.g. LiquidCrystal_I2C)...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.search,
                        color: AppColors.accentCyan, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            tooltip: 'Clear search',
                            icon: const Icon(Icons.clear,
                                color: Colors.white54, size: 18),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF475569)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.accentCyan),
                    ),
                  ),
                  onChanged: (text) => setState(() {}),
                ),
                const SizedBox(height: 12),

                // Search Result Card
                if (matchesQuery)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _isInstalled
                            ? AppColors.success
                            : const Color(0xFF475569),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'LiquidCrystal I2C',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Version 1.1.2',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'by Frank de Brabander',
                          style: TextStyle(
                            color: AppColors.accentCyan,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'A library for I2C LCD displays. Allows command and text output on 16x2 HD44780 displays via PCF8574 2-wire serial bus.',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        const SizedBox(height: 12),

                        // Install Progress or Button
                        if (_isInstalling) ...[
                          LinearProgressIndicator(
                            value: _installProgress,
                            minHeight: 8,
                            backgroundColor: const Color(0xFF0F172A),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.accentCyan,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _installStatusText,
                            style: const TextStyle(
                              color: AppColors.accentCyan,
                              fontSize: 10,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ] else if (_isInstalled) ...[
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.success),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle,
                                    color: AppColors.success, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'INSTALLED & READY TO #INCLUDE',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          ElevatedButton.icon(
                            key: const Key('library_install_button'),
                            onPressed: _startInstall,
                            icon: const Icon(Icons.download, size: 16),
                            label: const Text('INSTALL'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryViolet,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    child: const Text(
                      'No matching libraries found. Try searching "LiquidCrystal_I2C".',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
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
