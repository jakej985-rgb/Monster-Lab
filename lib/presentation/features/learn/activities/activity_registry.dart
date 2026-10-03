import 'package:flutter/material.dart';
import '../widgets/visual_flow_diagram_widget.dart';
import '../widgets/input_output_classification_widget.dart';
import '../widgets/interactive_board_inspector_widget.dart';
import '../widgets/board_label_drag_drop_widget.dart';
import '../widgets/ground_troubleshooting_widget.dart';
import '../widgets/decision_simulator_widget.dart';
import '../widgets/code_deconstruction_widget.dart';
import '../widgets/engineering_prediction_widget.dart';
import '../widgets/real_world_system_diagram_widget.dart';
import '../widgets/interactive_troubleshooting_widget.dart';
import '../widgets/mini_quiz_widget.dart';
import '../widgets/blink_simulator_widget.dart';
import '../widgets/potentiometer_simulator_widget.dart';
import '../widgets/rgb_mixer_widget.dart';

typedef ActivityWidgetBuilder = Widget Function(
  BuildContext context,
  Map<String, dynamic>? config,
  VoidCallback? onComplete,
);

/// Central Extensible Registry for all Monster Lab Interactive Lesson Activities
class ActivityRegistry {
  static final Map<String, ActivityWidgetBuilder> _builders = {
    'visualFlowDiagram': (context, config, onComplete) =>
        VisualFlowDiagramWidget(config: config, onComplete: onComplete),
    'inputOutputClassification': (context, config, onComplete) =>
        InputOutputClassificationWidget(config: config, onComplete: onComplete),
    'arduinoBoardInspector': (context, config, onComplete) =>
        InteractiveBoardInspectorWidget(config: config, onComplete: onComplete),
    'boardInspector': (context, config, onComplete) =>
        InteractiveBoardInspectorWidget(config: config, onComplete: onComplete),
    'boardLabelDragDrop': (context, config, onComplete) =>
        BoardLabelDragDropWidget(config: config, onComplete: onComplete),
    'groundTroubleshooting': (context, config, onComplete) =>
        GroundTroubleshootingWidget(config: config, onComplete: onComplete),
    'decisionSimulator': (context, config, onComplete) =>
        DecisionSimulatorWidget(config: config, onComplete: onComplete),
    'codeDeconstruction': (context, config, onComplete) =>
        CodeDeconstructionWidget(config: config, onComplete: onComplete),
    'engineeringPrediction': (context, config, onComplete) =>
        EngineeringPredictionWidget(config: config, onComplete: onComplete),
    'realWorldSystemDiagram': (context, config, onComplete) =>
        RealWorldSystemDiagramWidget(config: config, onComplete: onComplete),
    'interactiveTroubleshooting': (context, config, onComplete) =>
        InteractiveTroubleshootingWidget(
            config: config, onComplete: onComplete),
    'miniQuiz': (context, config, onComplete) =>
        MiniQuizWidget(config: config, onComplete: onComplete),
    'blinkSimulator': (context, config, onComplete) =>
        const BlinkSimulatorWidget(),
    'potentiometerSimulator': (context, config, onComplete) =>
        const PotentiometerSimulatorWidget(),
    'rgbMixer': (context, config, onComplete) => const RgbMixerWidget(),
  };

  /// Register or override an activity builder
  static void register(String activityType, ActivityWidgetBuilder builder) {
    _builders[activityType] = builder;
  }

  /// Whether an activity type has a registered widget
  static bool hasActivity(String? activityType) {
    if (activityType == null) return false;
    return _builders.containsKey(activityType);
  }

  /// Builds the activity widget for the given type and config.
  /// Returns null if no builder is registered for [activityType].
  static Widget? buildActivity({
    required BuildContext context,
    required String? activityType,
    Map<String, dynamic>? config,
    VoidCallback? onComplete,
  }) {
    if (activityType == null) return null;
    final builder = _builders[activityType];
    if (builder == null) return null;
    return builder(context, config, onComplete);
  }
}
