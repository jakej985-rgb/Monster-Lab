import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/models/circuit_wiring_model.dart';
import '../../../shared/widgets/monster_button.dart';
import '../../../shared/widgets/monster_card.dart';
import 'breadboard_painter.dart';

class InteractiveBreadboardWidget extends StatefulWidget {
  final CircuitPreset preset;

  const InteractiveBreadboardWidget({
    super.key,
    required this.preset,
  });

  @override
  State<InteractiveBreadboardWidget> createState() =>
      _InteractiveBreadboardWidgetState();
}

class _InteractiveBreadboardWidgetState
    extends State<InteractiveBreadboardWidget> {
  final List<JumperWire> _wires = [];
  String? _selectedPinId;
  Color _selectedWireColor = AppColors.wireDigital;
  WiringValidationResult? _validationResult;

  static const List<Color> _palette = [
    AppColors.wirePower5V,
    AppColors.wireGround,
    AppColors.wireDigital,
    AppColors.wireAnalog,
    AppColors.accentCyanDark,
    AppColors.primaryViolet,
  ];

  @override
  void didUpdateWidget(covariant InteractiveBreadboardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.preset.id != widget.preset.id) {
      _wires.clear();
      _selectedPinId = null;
      _validationResult = null;
    }
  }

  void _handleTapDown(TapDownDetails details, Size canvasSize) {
    final localPos = details.localPosition;
    WiringPin? tappedPin;
    double minDistance = 28.0; // 28dp touch target radius

    for (final pin in widget.preset.allPins) {
      final pinPos =
          Offset(pin.x * canvasSize.width, pin.y * canvasSize.height);
      final dist = (pinPos - localPos).distance;
      if (dist < minDistance) {
        minDistance = dist;
        tappedPin = pin;
      }
    }

    if (tappedPin == null) {
      setState(() => _selectedPinId = null);
      return;
    }

    if (_selectedPinId == null) {
      setState(() {
        _selectedPinId = tappedPin!.id;
        _selectedWireColor = tappedPin.type.defaultColor;
      });
    } else {
      if (_selectedPinId == tappedPin.id) {
        setState(() => _selectedPinId = null);
      } else {
        // Create wire between selectedPinId and tappedPin.id
        final pinA = _selectedPinId!;
        final pinB = tappedPin.id;

        // Check if wire already exists
        final alreadyExists = _wires.any((w) => w.connects(pinA, pinB));
        if (!alreadyExists) {
          setState(() {
            _wires.add(
              JumperWire(
                id: 'wire_${DateTime.now().millisecondsSinceEpoch}_${math.Random().nextInt(100)}',
                fromPinId: pinA,
                toPinId: pinB,
                color: _selectedWireColor,
              ),
            );
            _selectedPinId = null;
            _validationResult = null;
          });
        } else {
          setState(() => _selectedPinId = null);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Description Card
        MonsterCard(
          color: AppColors.primaryViolet.withValues(alpha: 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.preset.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryViolet,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.preset.description,
                style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Controls bar: Wire color picker & Clear/Undo buttons
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          runSpacing: 4,
          children: [
            const Text(
              'Wire Color: ',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            ..._palette.map((c) {
              final isChosen = _selectedWireColor == c;
              final colorName = _getWireColorName(c);
              return Semantics(
                button: true,
                selected: isChosen,
                label: '$colorName wire',
                child: InkWell(
                  onTap: () => setState(() => _selectedWireColor = c),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isChosen ? Colors.black : Colors.white,
                          width: isChosen ? 2.5 : 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            TextButton.icon(
              key: const Key('undo_wire_button'),
              icon: const Icon(Icons.undo, size: 16),
              label: const Text('Undo Wire'),
              onPressed: _wires.isEmpty
                  ? null
                  : () {
                      setState(() {
                        _wires.removeLast();
                        _validationResult = null;
                      });
                    },
            ),
            TextButton.icon(
              key: const Key('clear_wires_button'),
              icon: const Icon(Icons.delete_outline, size: 16),
              label: const Text('Clear'),
              onPressed: _wires.isEmpty
                  ? null
                  : () {
                      setState(() {
                        _wires.clear();
                        _selectedPinId = null;
                        _validationResult = null;
                      });
                    },
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Interactive Breadboard Canvas
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = (width * 0.58).clamp(240.0, 360.0);
              final size = Size(width, height);

              return GestureDetector(
                key: const Key('breadboard_gesture_detector'),
                onTapDown: (details) => _handleTapDown(details, size),
                child: CustomPaint(
                  size: size,
                  painter: BreadboardPainter(
                    preset: widget.preset,
                    wires: _wires,
                    selectedPinId: _selectedPinId,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Wire count & Verify button
        Builder(
          builder: (context) {
            final isLargeScale =
                MediaQuery.textScalerOf(context).scale(1.0) > 1.1 ||
                    MediaQuery.sizeOf(context).width < 500;
            final countText = Text(
              'Placed Wires: ${_wires.length} • Tap two pins to connect',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            );
            final verifyBtn = MonsterButton(
              key: const Key('verify_wiring_button'),
              label: 'Verify Circuit Wiring',
              icon: Icons.check_circle_outline,
              onPressed: () {
                setState(() {
                  _validationResult = widget.preset.validator(_wires);
                });
              },
            );

            if (isLargeScale) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  countText,
                  const SizedBox(height: 8),
                  verifyBtn,
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: countText),
                const SizedBox(width: 8),
                verifyBtn,
              ],
            );
          },
        ),
        const SizedBox(height: 12),

        // Validation Feedback Card
        if (_validationResult != null)
          _buildValidationFeedback(_validationResult!),
      ],
    );
  }

  Widget _buildValidationFeedback(WiringValidationResult result) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isSuccess = result.isValid;
    final color = isSuccess
        ? (isDark ? AppColors.success : AppColors.textSuccessOnLight)
        : AppColors.danger;
    final bgColor = isSuccess ? AppColors.success : AppColors.danger;
    final icon = isSuccess ? Icons.verified : Icons.warning_amber_rounded;

    return Semantics(
      liveRegion: true,
      label: '${result.title}: ${result.message}',
      child: MonsterCard(
        color: bgColor.withValues(alpha: 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    result.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              result.message,
              style: const TextStyle(fontSize: 14, height: 1.3),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.school,
                      size: 18, color: AppColors.primaryViolet),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 13,
                            height: 1.3),
                        children: [
                          const TextSpan(
                            text: 'The Science: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryViolet),
                          ),
                          TextSpan(text: result.educationalTip),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getWireColorName(Color c) {
    if (c == AppColors.wirePower5V) return 'Red (+5V power)';
    if (c == AppColors.wireGround) return 'Black (GND ground)';
    if (c == AppColors.wireDigital) return 'Green (digital signal)';
    if (c == AppColors.wireI2C) return 'Blue (I2C/analog signal)';
    if (c == AppColors.wireSPI) return 'Amber/Orange (SPI signal)';
    return 'Wire';
  }
}
