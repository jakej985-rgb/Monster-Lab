import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

enum _RfidReadStage {
  loadModulation,
  readerReception,
  spiTransfer,
  serialOutput,
}

/// A deterministic teaching model of passive RFID coupling and an SPI UID read.
class RfidCouplingSimulatorWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const RfidCouplingSimulatorWidget({super.key, this.config, this.onComplete});

  @override
  State<RfidCouplingSimulatorWidget> createState() =>
      _RfidCouplingSimulatorWidgetState();
}

class _RfidCouplingSimulatorWidgetState
    extends State<RfidCouplingSimulatorWidget> {
  double _distanceCm = 5.0;
  _RfidReadStage? _stage;
  bool _isReading = false;

  double _numberConfig(String key, double fallback) {
    final value = widget.config?[key];
    return value is num && value.isFinite ? value.toDouble() : fallback;
  }

  double get _frequencyMHz => _numberConfig('frequencyMHz', 13.56);
  double get _readRangeCm => _numberConfig('readRangeCm', 3.0);
  String get _demoUid => widget.config?['demoUid'] as String? ?? 'DE AD BE EF';
  bool get _tagPowered => _distanceCm <= _readRangeCm;

  Future<void> _readUid() async {
    if (!_tagPowered || _isReading) return;
    setState(() {
      _isReading = true;
      _stage = null;
    });

    for (final stage in _RfidReadStage.values) {
      await Future<void>.delayed(const Duration(milliseconds: 450));
      if (!mounted) return;
      setState(() => _stage = stage);
    }

    if (!mounted) return;
    setState(() => _isReading = false);
    widget.onComplete?.call();
  }

  void _reset() {
    setState(() {
      _distanceCm = 5.0;
      _stage = null;
      _isReading = false;
    });
  }

  void _setDistance(double value) {
    setState(() {
      _distanceCm = value;
      _stage = null;
      _isReading = false;
    });
  }

  String _stageLabel(_RfidReadStage stage) => switch (stage) {
    _RfidReadStage.loadModulation => 'Tag load modulation: response sent',
    _RfidReadStage.readerReception => 'RC522 receives the tag response',
    _RfidReadStage.spiTransfer => 'SPI transfer: RC522 → Uno over MISO',
    _RfidReadStage.serialOutput => 'Serial Monitor: example UID $_demoUid',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title =
        widget.config?['title'] as String? ??
        'RFID Coupling & UID Read Simulator';
    final range = _readRangeCm;
    final powered = _tagPowered;

    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.accentCyan,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Teaching model: the reader field operates at ${_frequencyMHz.toStringAsFixed(2)} MHz. '
            'The simulated tag powers within ${range.toStringAsFixed(1)} cm threshold '
            '(physical range varies with reader/tag antennas, tuning, and power).',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: powered
                    ? AppColors.success
                    : AppColors.surfaceContainerDark,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _device(
                      'RC522 reader',
                      Icons.sensors,
                      AppColors.accentCyan,
                    ),
                    Icon(
                      Icons.waves,
                      color: powered ? AppColors.success : Colors.white38,
                    ),
                    _device(
                      'Passive tag',
                      Icons.credit_card,
                      powered ? AppColors.success : Colors.white54,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Drag the tag or use the distance slider',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(
                  height: 48,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const tagWidth = 48.0;
                      final available = (constraints.maxWidth - tagWidth).clamp(
                        0.0,
                        double.infinity,
                      );
                      final left =
                          available *
                          (_distanceCm / 6).clamp(0.0, 1.0).toDouble();
                      return Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            child: Container(height: 3, color: Colors.white24),
                          ),
                          Positioned(
                            left:
                                available *
                                (range / 6).clamp(0.0, 1.0).toDouble(),
                            child: Container(
                              width: 2,
                              height: 22,
                              color: AppColors.energyAmber,
                            ),
                          ),
                          Positioned(
                            left: left,
                            child: GestureDetector(
                              key: const Key('rfid_tag_drag'),
                              behavior: HitTestBehavior.opaque,
                              onHorizontalDragUpdate: _isReading
                                  ? null
                                  : (details) => _setDistance(
                                      (_distanceCm +
                                              details.delta.dx /
                                                  (available <= 0
                                                      ? 1
                                                      : available) *
                                                  6)
                                          .clamp(0.0, 6.0)
                                          .toDouble(),
                                    ),
                              child: Container(
                                width: tagWidth,
                                height: 44,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: powered
                                      ? AppColors.success.withValues(alpha: 0.2)
                                      : Colors.white10,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.credit_card,
                                  color: powered
                                      ? AppColors.success
                                      : Colors.white70,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Semantics(
                  label:
                      'Tag distance control. Current distance ${_distanceCm.toStringAsFixed(1)} centimeters.',
                  child: Slider(
                    key: const Key('rfid_distance_slider'),
                    value: _distanceCm,
                    min: 0,
                    max: 6,
                    divisions: 12,
                    label: '${_distanceCm.toStringAsFixed(1)} cm',
                    semanticFormatterCallback: (value) =>
                        '${value.toStringAsFixed(1)} centimeters',
                    onChanged: _isReading ? null : _setDistance,
                  ),
                ),
                Text(
                  'Tag distance: ${_distanceCm.toStringAsFixed(1)} cm',
                  key: const Key('rfid_distance_value'),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  powered
                      ? 'TAG POWERED — IN RANGE'
                      : 'TAG NOT POWERED — OUT OF RANGE',
                  key: const Key('rfid_power_state'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: powered ? AppColors.success : AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                key: const Key('rfid_read_uid'),
                onPressed: powered && !_isReading ? _readUid : null,
                icon: const Icon(Icons.nfc),
                label: Text(_isReading ? 'Reading tag…' : 'Read UID'),
              ),
              OutlinedButton.icon(
                key: const Key('rfid_reset'),
                onPressed: _isReading ? null : _reset,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _signalRow('MOSI', 'Uno → RC522: command data'),
          _signalRow('SCK', 'Uno → RC522: clock'),
          _signalRow('CS', 'Uno → RC522: select reader'),
          _signalRow('MISO', 'RC522 → Uno: returned UID bytes'),
          const SizedBox(height: 8),
          if (_stage != null)
            Container(
              key: const Key('rfid_stage_status'),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _stageLabel(_stage!),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          if (_stage == _RfidReadStage.serialOutput) ...[
            const SizedBox(height: 8),
            Container(
              key: const Key('rfid_serial_output'),
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'UID (example): $_demoUid',
                style: const TextStyle(
                  color: AppColors.success,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _device(String label, IconData icon, Color color) => Column(
    children: [
      Icon(icon, color: color, size: 32),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(color: Colors.white)),
    ],
  );

  Widget _signalRow(String signal, String description) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        SizedBox(
          width: 46,
          child: Text(
            signal,
            style: const TextStyle(
              color: AppColors.accentCyan,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    ),
  );
}
