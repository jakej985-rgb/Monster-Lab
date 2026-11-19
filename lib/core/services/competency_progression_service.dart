import '../../domain/models/learner_progress_model.dart';

enum SkillMasteryLevel {
  novice,
  apprentice,
  expert,
  master,
}

class CompetencySkillTrack {
  final String id;
  final String title;
  final String description;
  final double progressRatio; // 0.0 to 1.0
  final SkillMasteryLevel masteryLevel;
  final int completedItems;
  final int totalItems;
  final List<String> verifiedOutcomes;

  const CompetencySkillTrack({
    required this.id,
    required this.title,
    required this.description,
    required this.progressRatio,
    required this.masteryLevel,
    required this.completedItems,
    required this.totalItems,
    required this.verifiedOutcomes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'progressRatio': progressRatio,
        'masteryLevel': masteryLevel.name,
        'completedItems': completedItems,
        'totalItems': totalItems,
        'verifiedOutcomes': verifiedOutcomes,
      };
}

class CompetencyProgressionService {
  /// Evaluates verified progress against the 6 core STEM competencies
  static List<CompetencySkillTrack> evaluateCompetencies(
      LearnerProgressModel progress) {
    return [
      _evaluateTrack(
        id: 'competency_circuitry',
        title: 'Basic Circuitry & Closed Loops',
        description:
            'Breadboard fundamentals, current loops, resistors, and LED polarity.',
        items: const [
          'l01_01',
          'l01_02',
          'l01_05',
          'proj_01',
          'chal_01',
          'chal_09'
        ],
        progress: progress,
        outcomeNames: [
          'Closed electrical circuits and safe breadboard routing',
          'Current limiting resistors and Ohm\'s Law fundamentals',
          'Series and parallel component configurations',
        ],
      ),
      _evaluateTrack(
        id: 'competency_coding',
        title: 'Embedded C++ & Control Flow',
        description:
            'setup(), loop(), variables, conditional logic, and PWM output.',
        items: const [
          'l01_07',
          'l01_08',
          'l01_10',
          'proj_03',
          'chal_04',
          'chal_07'
        ],
        progress: progress,
        outcomeNames: [
          'Arduino setup() and infinite loop execution cycle',
          'Variables, pin constants, and digital logic',
          'Pulse Width Modulation (PWM) and duty cycle timing',
        ],
      ),
      _evaluateTrack(
        id: 'competency_sensors',
        title: 'Sensors & Analog Telemetry',
        description:
            'Reading physical signals: light, temperature, ultrasonic distance, and motion.',
        items: const [
          'l01_06',
          'comp_19',
          'comp_20',
          'proj_02',
          'chal_02',
          'chal_08'
        ],
        progress: progress,
        outcomeNames: [
          'Voltage divider circuits with analog sensors',
          'Analog-to-Digital Conversion (ADC 0-1023)',
          'Ultrasonic echo timing and physical distance calculation',
        ],
      ),
      _evaluateTrack(
        id: 'competency_actuators',
        title: 'Motors & Physical Actuation',
        description:
            'Controlling servos, steppers, relays, buzzers, and mechanical devices.',
        items: const [
          'comp_25',
          'comp_27',
          'comp_36',
          'proj_08',
          'proj_10',
          'chal_10'
        ],
        progress: progress,
        outcomeNames: [
          'Pulse-width positioning of micro servo motors',
          'Inductive kickback suppression and flyback diodes',
          '4-phase stepper motor sequencing and torque control',
        ],
      ),
      _evaluateTrack(
        id: 'competency_protocols',
        title: 'Communication Buses (I2C/SPI/UART)',
        description:
            'Multi-device communication buses, addressing, and serial telemetry.',
        items: const [
          'comp_07',
          'comp_10',
          'proj_05',
          'chal_05',
          'chal_15',
          'chal_19'
        ],
        progress: progress,
        outcomeNames: [
          'I2C 2-wire serial protocol with unique device addressing',
          'SPI bus high-speed synchronous peripheral communication',
          'UART serial baud rate synchronization and debugging',
        ],
      ),
      _evaluateTrack(
        id: 'competency_troubleshooting',
        title: 'Diagnostic Debugging & Safety',
        description:
            'Root-cause isolation, floating pin mitigation, ESD safety, and circuit repair.',
        items: const [
          'chal_03',
          'chal_06',
          'chal_11',
          'chal_12',
          'chal_14',
          'chal_17'
        ],
        progress: progress,
        outcomeNames: [
          'Floating pin diagnosis and internal pullup resistor engagement',
          'Overvoltage, thermal hazard, and short circuit mitigation',
          'Systematic breadboard continuity isolation',
        ],
      ),
    ];
  }

  static CompetencySkillTrack _evaluateTrack({
    required String id,
    required String title,
    required String description,
    required List<String> items,
    required LearnerProgressModel progress,
    required List<String> outcomeNames,
  }) {
    int completedCount = 0;
    for (final item in items) {
      if (item.startsWith('l') || item.startsWith('lesson')) {
        if (progress.completedLessonIds.contains(item) ||
            progress.completedCourseIds.contains(item)) {
          completedCount++;
        }
      } else if (item.startsWith('proj')) {
        if (progress.completedProjectIds.contains(item)) {
          completedCount++;
        }
      } else if (item.startsWith('chal')) {
        if (progress.solvedChallengeIds.contains(item)) {
          completedCount++;
        }
      } else if (item.startsWith('comp')) {
        if (progress.discoveredComponentIds.contains(item)) {
          completedCount++;
        }
      }
    }

    final ratio =
        items.isEmpty ? 0.0 : (completedCount / items.length).clamp(0.0, 1.0);

    SkillMasteryLevel level;
    if (ratio >= 0.85) {
      level = SkillMasteryLevel.master;
    } else if (ratio >= 0.50) {
      level = SkillMasteryLevel.expert;
    } else if (ratio >= 0.20) {
      level = SkillMasteryLevel.apprentice;
    } else {
      level = SkillMasteryLevel.novice;
    }

    final verifiedOutcomes = <String>[];
    if (completedCount > 0 && outcomeNames.isNotEmpty) {
      final outcomesToInclude = (ratio * outcomeNames.length).ceil();
      verifiedOutcomes.addAll(outcomeNames.take(outcomesToInclude));
    }

    return CompetencySkillTrack(
      id: id,
      title: title,
      description: description,
      progressRatio: ratio,
      masteryLevel: level,
      completedItems: completedCount,
      totalItems: items.length,
      verifiedOutcomes: verifiedOutcomes,
    );
  }
}
