import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/circuit_wiring_model.dart';
import '../../../domain/models/code_experiment_model.dart';
import 'widgets/interactive_breadboard_widget.dart';
import 'widgets/guided_code_lab_widget.dart';

class InteractiveLabScreen extends StatefulWidget {
  const InteractiveLabScreen({super.key});

  @override
  State<InteractiveLabScreen> createState() => _InteractiveLabScreenState();
}

class _InteractiveLabScreenState extends State<InteractiveLabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CircuitPreset _selectedCircuitPreset = CircuitPresets.blinkLed;
  CodePreset _selectedCodePreset = CodePresets.blinkExperiment;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Interactive Wiring & Code Lab',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryViolet,
          indicatorWeight: 3,
          labelColor: AppColors.primaryViolet,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(
              icon: Icon(Icons.cable),
              text: 'Breadboard Wiring',
            ),
            Tab(
              icon: Icon(Icons.code),
              text: 'Guided Code Lab',
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Preset selector bar
          if (_tabController.index == 0) ...[
            _buildCircuitPresetSelector(),
            const SizedBox(height: 16),
            InteractiveBreadboardWidget(preset: _selectedCircuitPreset),
          ] else ...[
            _buildCodePresetSelector(),
            const SizedBox(height: 16),
            GuidedCodeLabWidget(preset: _selectedCodePreset),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCircuitPresetSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.developer_board,
              color: AppColors.primaryViolet, size: 20),
          const SizedBox(width: 10),
          const Text('Circuit: ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<CircuitPreset>(
                key: const Key('circuit_preset_dropdown'),
                value: _selectedCircuitPreset,
                isExpanded: true,
                items: CircuitPresets.all.map((p) {
                  return DropdownMenuItem<CircuitPreset>(
                    value: p,
                    child: Text(
                      p.title,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  );
                }).toList(),
                onChanged: (newPreset) {
                  if (newPreset != null) {
                    setState(() => _selectedCircuitPreset = newPreset);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodePresetSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.code, color: AppColors.accentCyanDark, size: 20),
          const SizedBox(width: 10),
          const Text('Experiment: ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<CodePreset>(
                key: const Key('code_preset_dropdown'),
                value: _selectedCodePreset,
                isExpanded: true,
                items: CodePresets.all.map((p) {
                  return DropdownMenuItem<CodePreset>(
                    value: p,
                    child: Text(
                      p.title,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  );
                }).toList(),
                onChanged: (newPreset) {
                  if (newPreset != null) {
                    setState(() => _selectedCodePreset = newPreset);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
