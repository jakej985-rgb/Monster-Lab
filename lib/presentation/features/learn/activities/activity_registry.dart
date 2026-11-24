import 'package:material_ui/material_ui.dart';
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
import '../widgets/prior_knowledge_check_widget.dart';
import '../widgets/compilation_pipeline_simulator_widget.dart';
import '../widgets/port_selector_bench_widget.dart';
import '../widgets/ide_lifecycle_simulator_widget.dart';
import '../widgets/port_troubleshooting_bench_widget.dart';
import '../widgets/esd_safety_check_widget.dart';
import '../widgets/library_concept_diagram_widget.dart';
import '../widgets/library_manager_simulator_widget.dart';
import '../widgets/include_syntax_deconstruction_widget.dart';
import '../widgets/lcd_contrast_simulator_widget.dart';
import '../widgets/missing_library_troubleshooting_widget.dart';
import '../widgets/syntax_error_debugger_widget.dart';
import '../widgets/serial_monitor_simulator_widget.dart';
import '../widgets/execution_speed_visualizer_widget.dart';
import '../widgets/serial_print_experiment_widget.dart';
import '../widgets/led_polarity_inspector_widget.dart';
import '../widgets/resistor_ohm_law_simulator_widget.dart';
import '../widgets/breadboard_internal_bus_inspector_widget.dart';
import '../widgets/blink_timing_lab_widget.dart';
import '../widgets/voltage_divider_cutaway_widget.dart';
import '../widgets/adc_sampling_visualizer_widget.dart';
import '../widgets/wiper_pinout_checker_widget.dart';
import '../widgets/analog_read_noise_filter_widget.dart';
import '../widgets/common_cathode_vs_anode_diagram_widget.dart';
import '../widgets/pwm_duty_cycle_visualizer_widget.dart';
import '../widgets/rgb_color_synthesizer_widget.dart';
import '../widgets/pwm_pin_identifier_widget.dart';
import '../widgets/floating_pin_simulator_widget.dart';
import '../widgets/internal_pullup_circuit_diagram_widget.dart';
import '../widgets/switch_bounce_visualizer_widget.dart';
import '../widgets/active_low_logic_checker_widget.dart';
import '../widgets/i2c_bus_timing_diagram_widget.dart';
import '../widgets/i2c_daisy_chain_simulator_widget.dart';
import '../widgets/i2c_address_scanner_widget.dart';
import '../widgets/i2c_pullup_checker_widget.dart';
import '../widgets/spi_full_duplex_visualizer_widget.dart';
import '../widgets/rfid_coupling_simulator_widget.dart';
import '../widgets/chip_select_arbitrator_widget.dart';
import '../widgets/spi_vs_i2c_comparison_widget.dart';
import '../widgets/spi_clock_polarity_phase_lab_widget.dart';
import '../widgets/uart_frame_visualizer_widget.dart';
import '../widgets/tx_rx_cross_wire_checker_widget.dart';
import '../widgets/bluetooth_at_command_terminal_widget.dart';
import '../widgets/baud_rate_mismatch_demo_widget.dart';
import '../widgets/inductive_kickback_simulator_widget.dart';
import '../widgets/h_bridge_direction_switch_widget.dart';
import '../widgets/servo_pulse_width_modulator_widget.dart';
import '../widgets/external_motor_power_lab_widget.dart';
import '../widgets/vocabulary_match_widget.dart';

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
    'vocabularyMatch': (context, config, onComplete) =>
        VocabularyMatchWidget(config: config, onComplete: onComplete),
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

    // Foundation Phase & Batch 1 Registered Activities
    'priorKnowledgeCheck': (context, config, onComplete) =>
        PriorKnowledgeCheckWidget(config: config, onComplete: onComplete),
    'compilationPipelineSimulator': (context, config, onComplete) =>
        CompilationPipelineSimulatorWidget(
            config: config, onComplete: onComplete),
    'portSelectorBench': (context, config, onComplete) =>
        PortSelectorBenchWidget(config: config, onComplete: onComplete),
    'ideLifecycleSimulator': (context, config, onComplete) =>
        IdeLifecycleSimulatorWidget(config: config, onComplete: onComplete),
    'portTroubleshootingBench': (context, config, onComplete) =>
        PortTroubleshootingBenchWidget(config: config, onComplete: onComplete),
    'esdSafetyCheck': (context, config, onComplete) =>
        EsdSafetyCheckWidget(config: config, onComplete: onComplete),
    'libraryConceptDiagram': (context, config, onComplete) =>
        LibraryConceptDiagramWidget(config: config, onComplete: onComplete),
    'libraryManagerSimulator': (context, config, onComplete) =>
        LibraryManagerSimulatorWidget(config: config, onComplete: onComplete),
    'includeSyntaxDeconstruction': (context, config, onComplete) =>
        IncludeSyntaxDeconstructionWidget(
            config: config, onComplete: onComplete),
    'lcdContrastSimulator': (context, config, onComplete) =>
        LcdContrastSimulatorWidget(config: config, onComplete: onComplete),
    'missingLibraryTroubleshooting': (context, config, onComplete) =>
        MissingLibraryTroubleshootingWidget(
            config: config, onComplete: onComplete),
    'syntaxErrorDebugger': (context, config, onComplete) =>
        SyntaxErrorDebuggerWidget(config: config, onComplete: onComplete),
    'serialMonitorSimulator': (context, config, onComplete) =>
        SerialMonitorSimulatorWidget(config: config, onComplete: onComplete),
    'executionSpeedVisualizer': (context, config, onComplete) =>
        ExecutionSpeedVisualizerWidget(config: config, onComplete: onComplete),
    'serialPrintExperiment': (context, config, onComplete) =>
        SerialPrintExperimentWidget(config: config, onComplete: onComplete),

    // Batch 2 Registered Activities (Lessons 05, 06, 07)
    'ledPolarityInspector': (context, config, onComplete) =>
        LedPolarityInspectorWidget(config: config, onComplete: onComplete),
    'resistorOhmLawSimulator': (context, config, onComplete) =>
        ResistorOhmLawSimulatorWidget(config: config, onComplete: onComplete),
    'breadboardInternalBusInspector': (context, config, onComplete) =>
        BreadboardInternalBusInspectorWidget(
            config: config, onComplete: onComplete),
    'blinkTimingLab': (context, config, onComplete) =>
        BlinkTimingLabWidget(config: config, onComplete: onComplete),
    'voltageDividerCutaway': (context, config, onComplete) =>
        VoltageDividerCutawayWidget(config: config, onComplete: onComplete),
    'adcSamplingVisualizer': (context, config, onComplete) =>
        AdcSamplingVisualizerWidget(config: config, onComplete: onComplete),
    'wiperPinoutChecker': (context, config, onComplete) =>
        WiperPinoutCheckerWidget(config: config, onComplete: onComplete),
    'analogReadNoiseFilter': (context, config, onComplete) =>
        AnalogReadNoiseFilterWidget(config: config, onComplete: onComplete),
    'commonCathodeVsAnodeDiagram': (context, config, onComplete) =>
        CommonCathodeVsAnodeDiagramWidget(
            config: config, onComplete: onComplete),
    'pwmDutyCycleVisualizer': (context, config, onComplete) =>
        PwmDutyCycleVisualizerWidget(config: config, onComplete: onComplete),
    'rgbColorSynthesizer': (context, config, onComplete) =>
        RgbColorSynthesizerWidget(config: config, onComplete: onComplete),
    'pwmPinIdentifier': (context, config, onComplete) =>
        PwmPinIdentifierWidget(config: config, onComplete: onComplete),

    // Batch 3 Registered Activities (Lessons 08, 09, 10)
    'floatingPinSimulator': (context, config, onComplete) =>
        FloatingPinSimulatorWidget(config: config, onComplete: onComplete),
    'internalPullupCircuitDiagram': (context, config, onComplete) =>
        InternalPullupCircuitDiagramWidget(
            config: config, onComplete: onComplete),
    'switchBounceVisualizer': (context, config, onComplete) =>
        SwitchBounceVisualizerWidget(config: config, onComplete: onComplete),
    'activeLowLogicChecker': (context, config, onComplete) =>
        ActiveLowLogicCheckerWidget(config: config, onComplete: onComplete),
    'i2cBusTimingDiagram': (context, config, onComplete) =>
        I2cBusTimingDiagramWidget(config: config, onComplete: onComplete),
    'i2cDaisyChainSimulator': (context, config, onComplete) =>
        I2cDaisyChainSimulatorWidget(config: config, onComplete: onComplete),
    'i2cAddressScanner': (context, config, onComplete) =>
        I2cAddressScannerWidget(config: config, onComplete: onComplete),
    'i2cPullupChecker': (context, config, onComplete) =>
        I2cPullupCheckerWidget(config: config, onComplete: onComplete),
    'spiFullDuplexVisualizer': (context, config, onComplete) =>
        SpiFullDuplexVisualizerWidget(config: config, onComplete: onComplete),
    'rfidCouplingSimulator': (context, config, onComplete) =>
        RfidCouplingSimulatorWidget(config: config, onComplete: onComplete),
    'chipSelectArbitrator': (context, config, onComplete) =>
        ChipSelectArbitratorWidget(config: config, onComplete: onComplete),
    'spiVsI2cComparison': (context, config, onComplete) =>
        SpiVsI2cComparisonWidget(config: config, onComplete: onComplete),
    'spiClockPolarityPhaseLab': (context, config, onComplete) =>
        SpiClockPolarityPhaseLabWidget(config: config, onComplete: onComplete),

    // Batch 4 Registered Activities (Lessons 11 & 12)
    'uartFrameVisualizer': (context, config, onComplete) =>
        UartFrameVisualizerWidget(config: config, onComplete: onComplete),
    'txRxCrossWireChecker': (context, config, onComplete) =>
        TxRxCrossWireCheckerWidget(config: config, onComplete: onComplete),
    'bluetoothAtCommandTerminal': (context, config, onComplete) =>
        BluetoothAtCommandTerminalWidget(
            config: config, onComplete: onComplete),
    'baudRateMismatchDemo': (context, config, onComplete) =>
        BaudRateMismatchDemoWidget(config: config, onComplete: onComplete),
    'inductiveKickbackSimulator': (context, config, onComplete) =>
        InductiveKickbackSimulatorWidget(
            config: config, onComplete: onComplete),
    'hBridgeDirectionSwitch': (context, config, onComplete) =>
        HBridgeDirectionSwitchWidget(config: config, onComplete: onComplete),
    'servoPulseWidthModulator': (context, config, onComplete) =>
        ServoPulseWidthModulatorWidget(config: config, onComplete: onComplete),
    'externalMotorPowerLab': (context, config, onComplete) =>
        ExternalMotorPowerLabWidget(config: config, onComplete: onComplete),
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
