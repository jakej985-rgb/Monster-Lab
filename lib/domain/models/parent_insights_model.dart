import 'learner_progress_model.dart';
import 'learner_profile_model.dart';

enum CompetencyStatus {
  upcoming,
  inProgress,
  mastered,
}

class StemCompetency {
  final String id;
  final String title;
  final String description;
  final double progressRatio; // 0.0 to 1.0
  final CompetencyStatus status;
  final List<String> skillsPracticed;

  const StemCompetency({
    required this.id,
    required this.title,
    required this.description,
    required this.progressRatio,
    required this.status,
    required this.skillsPracticed,
  });
}

class ParentCompetencyAnalyzer {
  static List<StemCompetency> analyzeCompetencies(
      LearnerProgressModel progress) {
    // 1. Basic Circuitry (Lessons 1 & 5, Proj 1, Chal 1 & 9)
    final circuitItems = [
      'lesson_01',
      'lesson_05',
      'proj_01',
      'chal_01',
      'chal_09'
    ];
    final circuitCompleted = circuitItems.where((id) {
      if (id.startsWith('lesson')) {
        return progress.completedLessonIds.contains(id) ||
            progress.completedCourseIds.contains(id);
      }
      if (id.startsWith('proj')) {
        return progress.completedProjectIds.contains(id);
      }
      if (id.startsWith('chal')) {
        return progress.solvedChallengeIds.contains(id);
      }
      return false;
    }).length;
    final circuitRatio =
        (circuitCompleted / circuitItems.length).clamp(0.0, 1.0);

    // 2. Analog Signals (Lesson 6, Components 19, 20, 22, Proj 8, 12, Chal 2, 8)
    final analogItems = ['lesson_06', 'comp_20', 'chal_02', 'chal_08'];
    final analogCompleted = analogItems.where((id) {
      if (id.startsWith('lesson')) {
        return progress.completedLessonIds.contains(id) ||
            progress.completedCourseIds.contains(id);
      }
      if (id.startsWith('comp')) {
        return progress.discoveredComponentIds.contains(id);
      }
      if (id.startsWith('chal')) {
        return progress.solvedChallengeIds.contains(id);
      }
      return false;
    }).length;
    final analogRatio = (analogCompleted / analogItems.length).clamp(0.0, 1.0);

    // 3. PWM & Color Synthesis (Lesson 7, Proj 3, Chal 4, 7)
    final pwmItems = ['lesson_07', 'proj_03', 'chal_04', 'chal_07'];
    final pwmCompleted = pwmItems.where((id) {
      if (id.startsWith('lesson')) {
        return progress.completedLessonIds.contains(id) ||
            progress.completedCourseIds.contains(id);
      }
      if (id.startsWith('proj')) {
        return progress.completedProjectIds.contains(id);
      }
      if (id.startsWith('chal')) {
        return progress.solvedChallengeIds.contains(id);
      }
      return false;
    }).length;
    final pwmRatio = (pwmCompleted / pwmItems.length).clamp(0.0, 1.0);

    // 4. Bus Protocols (Lesson 3, Components 7, 10, Proj 5, Chal 5, 15)
    final busItems = ['lesson_03', 'comp_07', 'chal_05', 'chal_15'];
    final busCompleted = busItems.where((id) {
      if (id.startsWith('lesson')) {
        return progress.completedLessonIds.contains(id) ||
            progress.completedCourseIds.contains(id);
      }
      if (id.startsWith('comp')) {
        return progress.discoveredComponentIds.contains(id);
      }
      if (id.startsWith('chal')) {
        return progress.solvedChallengeIds.contains(id);
      }
      return false;
    }).length;
    final busRatio = (busCompleted / busItems.length).clamp(0.0, 1.0);

    // 5. State Machines & Interactive Logic (Proj 4, 7, 9, Chal 13, 16)
    final logicItems = ['proj_04', 'chal_13', 'chal_16'];
    final logicCompleted = logicItems.where((id) {
      if (id.startsWith('proj')) {
        return progress.completedProjectIds.contains(id);
      }
      if (id.startsWith('chal')) {
        return progress.solvedChallengeIds.contains(id);
      }
      return false;
    }).length;
    final logicRatio = (logicCompleted / logicItems.length).clamp(0.0, 1.0);

    // 6. Systematic Hardware Troubleshooting (Chal 3, 6, 11, 12, 14)
    final debugItems = ['chal_03', 'chal_06', 'chal_11', 'chal_12', 'chal_14'];
    final debugCompleted = debugItems
        .where((id) => progress.solvedChallengeIds.contains(id))
        .length;
    final debugRatio = (debugCompleted / debugItems.length).clamp(0.0, 1.0);

    CompetencyStatus getStatus(double ratio) {
      if (ratio >= 0.75) {
        return CompetencyStatus.mastered;
      }
      if (ratio > 0.0) {
        return CompetencyStatus.inProgress;
      }
      return CompetencyStatus.upcoming;
    }

    return [
      StemCompetency(
        id: 'comp_circuits',
        title: 'Basic Circuitry & Closed Loops',
        description:
            'Understands power, ground reference, polarity, and current-limiting resistors.',
        progressRatio: circuitRatio,
        status: getStatus(circuitRatio),
        skillsPracticed: [
          'Closed loop completion (5V to GND)',
          'Anode vs cathode LED orientation',
          'Current calculation with 220Ω resistors',
        ],
      ),
      StemCompetency(
        id: 'comp_analog',
        title: 'Analog Signals & Voltage Dividers',
        description:
            'Reads continuous real-world sensor values and understands 10-bit analog conversion.',
        progressRatio: analogRatio,
        status: getStatus(analogRatio),
        skillsPracticed: [
          'Potentiometer voltage division',
          '10-bit ADC mapping (0 to 1023)',
          'Environmental sensor calibration',
        ],
      ),
      StemCompetency(
        id: 'comp_pwm',
        title: 'PWM & Color Synthesis',
        description:
            'Applies pulse-width modulation to vary motor speed and mix additive light frequencies.',
        progressRatio: pwmRatio,
        status: getStatus(pwmRatio),
        skillsPracticed: [
          'analogWrite() 8-bit duty cycles (0 to 255)',
          'Additive color mixing (Red + Green = Yellow)',
          'Duty cycle frequency modulation',
        ],
      ),
      StemCompetency(
        id: 'comp_bus',
        title: 'Digital Bus Protocols (I2C & SPI)',
        description:
            'Communicates with smart peripherals over shared multi-device communication buses.',
        progressRatio: busRatio,
        status: getStatus(busRatio),
        skillsPracticed: [
          'I2C SDA and SCL two-wire bus',
          'Unique hex address routing (0x27 vs 0x3F)',
          'Hardware SPI high-speed serial',
        ],
      ),
      StemCompetency(
        id: 'comp_logic',
        title: 'State Machines & Automation Logic',
        description:
            'Designs algorithmic decision trees, conditional statements, and timing sequences.',
        progressRatio: logicRatio,
        status: getStatus(logicRatio),
        skillsPracticed: [
          'Compound boolean logic (&& and ||)',
          'Hardware-software state tracking',
          'Non-blocking delay timing',
        ],
      ),
      StemCompetency(
        id: 'comp_debugging',
        title: 'Systematic Hardware Debugging',
        description:
            'Applies the scientific method to isolate hardware, wiring, and code glitches.',
        progressRatio: debugRatio,
        status: getStatus(debugRatio),
        skillsPracticed: [
          'Floating input pin stabilization (INPUT_PULLUP)',
          'Flyback diode back-EMF protection',
          'Hardware serial conflict resolution',
        ],
      ),
    ];
  }

  static String generateQuickTake(
      LearnerProfileModel profile, LearnerProgressModel progress) {
    final name = profile.nickname;
    final lessons = progress.completedLessonIds.length;
    final projects = progress.completedProjectIds.length;
    final challenges = progress.solvedChallengeIds.length;

    if (lessons == 0 && projects == 0 && challenges == 0) {
      return '$name is at the starting gate of the Monster Lab journey! Encourage them to open Lesson 1 to meet their Arduino and make their first LED light up.';
    }

    if (projects > 0) {
      return '$name is actively engineering real physical monsters! With $projects project${projects == 1 ? "" : "s"} built and $challenges challenge${challenges == 1 ? "" : "s"} solved, they are gaining authentic hardware intuition and problem-solving confidence.';
    }

    if (lessons >= 5) {
      return '$name has mastered core electronics fundamentals ($lessons lessons completed). They are primed and ready to assemble their very first physical build in the Build Lab!';
    }

    return '$name is making steady progress through the foundational curriculum ($lessons completed lessons, Level ${progress.currentLevel}). They are developing hands-on familiarity with breadboards, components, and code logic.';
  }

  static String getRecommendedFocus(LearnerProgressModel progress) {
    if (progress.completedLessonIds.length < 5) {
      return 'Foundational lessons: Complete through Lesson 5 (Blink) to unlock first physical builds.';
    }
    if (progress.completedProjectIds.isEmpty) {
      return 'Hands-on construction: Build Project 1 (Intruder Alarm MONSTER) to apply sonar wiring.';
    }
    if (progress.solvedChallengeIds.length < 4) {
      return 'Conceptual mastery: Tackle Rookie & Builder quests in the Challenge Arena.';
    }
    return 'Advanced engineering: Explore intermediate projects and Doctor Monster debugging clinics.';
  }
}
