import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_constants.dart';
import '../../../core/services/parent_session_service.dart';
import '../../shared/widgets/monster_button.dart';
import '../../shared/widgets/monster_card.dart';

class ParentGateDialog extends StatefulWidget {
  final int? fixedA;
  final int? fixedB;
  final VoidCallback? onVerified;
  final VoidCallback? onCancel;
  final bool embedded;

  const ParentGateDialog({
    super.key,
    this.fixedA,
    this.fixedB,
    this.onVerified,
    this.onCancel,
    this.embedded = false,
  });

  @override
  State<ParentGateDialog> createState() => _ParentGateDialogState();
}

class _ParentGateDialogState extends State<ParentGateDialog> {
  final TextEditingController _controller = TextEditingController();
  late int _a;
  late int _b;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initProblem();
  }

  void _initProblem() {
    if (widget.fixedA != null && widget.fixedB != null) {
      _a = widget.fixedA!;
      _b = widget.fixedB!;
    } else {
      final rng = math.Random();
      _a = 6 + rng.nextInt(7); // 6 to 12
      _b = 6 + rng.nextInt(7); // 6 to 12
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _verify() {
    final entered = int.tryParse(_controller.text.trim());
    final expected = _a * _b;
    if (entered == expected) {
      appParentSessionService.authenticate();
      if (widget.onVerified != null) {
        widget.onVerified!();
        return;
      }
      try {
        context.pushReplacement(RoutePaths.parent);
      } catch (_) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(true);
        }
      }
    } else {
      setState(() {
        _error = 'Incorrect answer. Please calculate $_a × $_b.';
        _controller.clear();
      });
    }
  }

  void _cancel() {
    if (widget.onCancel != null) {
      widget.onCancel!();
      return;
    }
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      try {
        context.go(RoutePaths.home);
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: MonsterCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.security,
                  size: 64,
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Grown-Ups Only',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'To access insights, settings, and progress management, please solve:\n\n$_a × $_b = ?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Answer',
                    errorText: _error,
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _verify(),
                ),
                const SizedBox(height: 20),
                MonsterButton(
                  label: 'Verify & Enter',
                  onPressed: _verify,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _cancel,
                  child: Text(
                    widget.embedded ? 'Cancel' : 'Return to Monster Lab',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (widget.embedded) return content;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parental Verification'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: _cancel,
        ),
      ),
      body: content,
    );
  }
}
