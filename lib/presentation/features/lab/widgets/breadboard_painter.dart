import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/models/circuit_wiring_model.dart';

class BreadboardPainter extends CustomPainter {
  final CircuitPreset preset;
  final List<JumperWire> wires;
  final String? selectedPinId;

  BreadboardPainter({
    required this.preset,
    required this.wires,
    this.selectedPinId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBreadboardSurface(canvas, size);
    _drawComponentCards(canvas, size);
    _drawPins(canvas, size);
    _drawWires(canvas, size);
  }

  void _drawBreadboardSurface(Canvas canvas, Size size) {
    // 1. Breadboard background card
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(8, 8, size.width - 16, size.height - 16),
      const Radius.circular(16),
    );

    final bgPaint = Paint()..color = const Color(0xFFF7F8FA);
    final borderPaint = Paint()
      ..color = const Color(0xFFDCDDE1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRRect(rect, bgPaint);
    canvas.drawRRect(rect, borderPaint);

    // 2. Power rails (+ Red, - Blue)
    final redRailPaint = Paint()
      ..color = AppColors.wirePower5V
      ..strokeWidth = 3.0;
    final blueRailPaint = Paint()
      ..color = AppColors.accentCyanDark
      ..strokeWidth = 3.0;

    // Top power strip
    canvas.drawLine(
      const Offset(24, 20),
      Offset(size.width - 24, 20),
      redRailPaint,
    );
    canvas.drawLine(
      const Offset(24, 26),
      Offset(size.width - 24, 26),
      blueRailPaint,
    );

    // Bottom power strip
    canvas.drawLine(
      Offset(24, size.height - 26),
      Offset(size.width - 24, size.height - 26),
      redRailPaint,
    );
    canvas.drawLine(
      Offset(24, size.height - 20),
      Offset(size.width - 24, size.height - 20),
      blueRailPaint,
    );

    // Center divider gutter
    final gutterPaint = Paint()
      ..color = const Color(0xFFE2E4E9)
      ..strokeWidth = 6.0;
    canvas.drawLine(
      Offset(24, size.height / 2),
      Offset(size.width - 24, size.height / 2),
      gutterPaint,
    );
  }

  void _drawComponentCards(Canvas canvas, Size size) {
    // Arduino Uno Section Background (Left)
    final unoRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(18, 40, size.width * 0.28, size.height - 80),
      const Radius.circular(12),
    );
    final unoPaint = Paint()
      ..color = const Color(0xFF00979D).withValues(alpha: 0.12);
    final unoBorder = Paint()
      ..color = const Color(0xFF00979D).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawRRect(unoRect, unoPaint);
    canvas.drawRRect(unoRect, unoBorder);

    // Draw Uno Header Label
    _drawText(
      canvas,
      'Arduino Uno R3',
      const Offset(28, 48),
      const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Color(0xFF00979D),
      ),
    );

    // Component Sections (Right)
    for (final comp in preset.components) {
      if (comp.pins.isEmpty) continue;
      double minX = comp.pins.first.x;
      double maxX = comp.pins.first.x;
      double minY = comp.pins.first.y;
      double maxY = comp.pins.first.y;

      for (final p in comp.pins) {
        if (p.x < minX) minX = p.x;
        if (p.x > maxX) maxX = p.x;
        if (p.y < minY) minY = p.y;
        if (p.y > maxY) maxY = p.y;
      }

      final left = (minX * size.width) - 28;
      final right = (maxX * size.width) + 28;
      final top = (minY * size.height) - 34;
      final bottom = (maxY * size.height) + 34;

      final compRect = RRect.fromRectAndRadius(
        Rect.fromLTRB(left, top, right, bottom),
        const Radius.circular(10),
      );
      final compPaint = Paint()..color = Colors.white;
      final compBorder = Paint()
        ..color = const Color(0xFFCED6E0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;

      canvas.drawRRect(compRect, compPaint);
      canvas.drawRRect(compRect, compBorder);

      _drawText(
        canvas,
        comp.name,
        Offset(left + 8, top + 6),
        TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
        ),
      );
    }
  }

  void _drawPins(Canvas canvas, Size size) {
    for (final pin in preset.allPins) {
      final pinPos = Offset(pin.x * size.width, pin.y * size.height);
      final isSelected = pin.id == selectedPinId;

      // Glow halo if selected
      if (isSelected) {
        final haloPaint = Paint()
          ..color = AppColors.accentCyan.withValues(alpha: 0.35)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pinPos, 16, haloPaint);

        final pulsePaint = Paint()
          ..color = AppColors.accentCyan
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        canvas.drawCircle(pinPos, 16, pulsePaint);
      }

      // Outer pin terminal boot
      final bootPaint = Paint()..color = pin.type.defaultColor;
      canvas.drawCircle(pinPos, 8.5, bootPaint);

      // Inner shiny metal pin aperture
      final innerPaint = Paint()
        ..color = isSelected ? Colors.white : const Color(0xFF2F3542);
      canvas.drawCircle(pinPos, 4.0, innerPaint);

      // Pin Label
      _drawText(
        canvas,
        pin.label,
        Offset(pinPos.dx - 18, pinPos.dy + 12),
        const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2F3542),
        ),
      );
    }
  }

  void _drawWires(Canvas canvas, Size size) {
    for (final wire in wires) {
      final p1 = preset.findPin(wire.fromPinId);
      final p2 = preset.findPin(wire.toPinId);
      if (p1 == null || p2 == null) continue;

      final start = Offset(p1.x * size.width, p1.y * size.height);
      final end = Offset(p2.x * size.width, p2.y * size.height);

      // Natural cubic bezier droop
      final dx = (end.dx - start.dx).abs();
      final dy = (end.dy - start.dy).abs();
      final droop = 30.0 + (dx * 0.15) + (dy * 0.1);

      final cp1 = Offset(start.dx, start.dy + droop);
      final cp2 = Offset(end.dx, end.dy + droop);

      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, end.dx, end.dy);

      // 1. Drop shadow pass
      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

      canvas.drawPath(path.shift(const Offset(0, 4)), shadowPaint);

      // 2. Wire outer border (darker contrast)
      final borderPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0;
      canvas.drawPath(path, borderPaint);

      // 3. Main colored wire core
      final wirePaint = Paint()
        ..color = wire.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, wirePaint);

      // Terminal boots on both ends
      final endCapPaint = Paint()..color = wire.color;
      canvas.drawCircle(start, 5.0, endCapPaint);
      canvas.drawCircle(end, 5.0, endCapPaint);
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant BreadboardPainter oldDelegate) {
    return oldDelegate.preset != preset ||
        oldDelegate.wires.length != wires.length ||
        oldDelegate.selectedPinId != selectedPinId;
  }
}
