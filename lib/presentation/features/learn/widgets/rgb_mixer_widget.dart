import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class RgbMixerWidget extends StatefulWidget {
  const RgbMixerWidget({super.key});

  @override
  State<RgbMixerWidget> createState() => _RgbMixerWidgetState();
}

class _RgbMixerWidgetState extends State<RgbMixerWidget> {
  int _r = 255;
  int _g = 128;
  int _b = 0;

  Color get _mixedColor => Color.fromARGB(255, _r, _g, _b);

  void _setPreset(int r, int g, int b) {
    setState(() {
      _r = r;
      _g = g;
      _b = b;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.palette, color: AppColors.primaryViolet),
              SizedBox(width: 8),
              Text(
                'RGB LED PWM Color Studio',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Mixed Color Preview
          Center(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _mixedColor,
                    boxShadow: [
                      BoxShadow(
                        color: _mixedColor.withValues(alpha: 0.6),
                        blurRadius: 28,
                        spreadRadius: 6,
                      ),
                    ],
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.light_mode,
                      color: (_r * 0.299 + _g * 0.587 + _b * 0.114) > 150
                          ? Colors.black87
                          : Colors.white,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'RGB($_r, $_g, $_b)',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Red Slider
          _buildChannelSlider(
            label: 'Red (Pin 9 PWM)',
            value: _r,
            activeColor: AppColors.wirePower5V,
            onChanged: (v) => setState(() => _r = v),
          ),
          // Green Slider
          _buildChannelSlider(
            label: 'Green (Pin 10 PWM)',
            value: _g,
            activeColor: AppColors.wireDigital,
            onChanged: (v) => setState(() => _g = v),
          ),
          // Blue Slider
          _buildChannelSlider(
            label: 'Blue (Pin 11 PWM)',
            value: _b,
            activeColor: AppColors.wireI2C,
            onChanged: (v) => setState(() => _b = v),
          ),

          const SizedBox(height: 12),
          const Text('Quick Color Presets:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPresetChip('Red', 255, 0, 0),
              _buildPresetChip('Green', 0, 255, 0),
              _buildPresetChip('Blue', 0, 0, 255),
              _buildPresetChip('Yellow', 255, 255, 0),
              _buildPresetChip('Cyan', 0, 255, 255),
              _buildPresetChip('Purple', 255, 0, 255),
              _buildPresetChip('White', 255, 255, 255),
            ],
          ),

          const SizedBox(height: 16),
          // Generated Code Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '// Arduino PWM Output (8-bit: 0 to 255):\n'
              'analogWrite(RED_PIN,   $_r);\n'
              'analogWrite(GREEN_PIN, $_g);\n'
              'analogWrite(BLUE_PIN,  $_b);',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: AppColors.syntaxString,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelSlider({
    required String label,
    required int value,
    required Color activeColor,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            Text(
              '$value',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                color: activeColor,
              ),
            ),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 255,
          divisions: 255,
          activeColor: activeColor,
          label: '$value',
          onChanged: (v) => onChanged(v.round()),
        ),
      ],
    );
  }

  Widget _buildPresetChip(String name, int r, int g, int b) {
    final chipColor = Color.fromARGB(255, r, g, b);
    return ActionChip(
      avatar: CircleAvatar(backgroundColor: chipColor, radius: 8),
      label: Text(name, style: const TextStyle(fontSize: 12)),
      onPressed: () => _setPreset(r, g, b),
    );
  }
}
