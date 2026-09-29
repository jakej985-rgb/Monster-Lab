# 02 - Domain Models Specification

## 1. Overview

This document specifies the core domain models and value objects for **Monster Lab**. These pure Dart entities embody the business logic and educational rules of the application, independent of Flutter UI widgets or external third-party database libraries.

---

## 2. Curriculum Entities

### 2.1 Lesson & Lesson Step Model
```dart
class Lesson {
  final String id;                  // e.g. "lesson_06"
  final String title;               // e.g. "Potentiometer Readings"
  final String summary;             // Short kid-friendly hook
  final DifficultyTier tier;        // rookie, builder, engineer, monsterMaster
  final int estimatedMinutes;       // e.g. 15
  final List<String> prerequisites; // ['lesson_05']
  final List<String> componentIds;  // ['comp_20']
  final List<LessonStep> steps;     // Ordered sequence of pedagogical steps
  final int xpReward;               // e.g. 100
}

enum StepType { story, visualExplanation, physicalTask, interactiveWiring, codeExperiment, quizCheckpoint }

class LessonStep {
  final String stepId;
  final String title;
  final StepType type;
  final String markdownContent;
  final String? illustrationAsset;
  final String? interactiveWidgetType;
  final Map<String, dynamic>? interactiveConfig;
}
```

### 2.2 Component Model
```dart
class Component {
  final String id;                  // e.g. "comp_01"
  final int peripheralNumber;       // 1 to 38
  final String name;                // e.g. "Ultrasonic Sensor"
  final String partNumber;          // e.g. "HC-SR04"
  final String category;            // sensor, actuator, display, communication, passive, power
  final String description;         // Kid-friendly explanation of how it works
  final String realWorldAnalogy;    // "Works like a bat using echo location!"
  final OperatingVoltage voltage;   // v3_3, v5, dual
  final List<PinDefinition> pinout;
  final String datasheetRef;        // e.g. "hc-sr04_ultrasonic_module_user_guidejohn .pdf"
  final SafetyClassification safety;
  final MiniExperiment miniExperiment;
  final List<String> projectIds;    // ['proj_01', 'proj_11']
}

class PinDefinition {
  final String pinName;             // e.g. "TRIG", "VCC", "GND"
  final PinType type;               // power, ground, digitalIn, digitalOut, analogIn, i2c, spi, uart
  final String description;         // What this pin connects to
}

class SafetyClassification {
  final SafetyLevel level;          // safe, caution, restrictedAdultSupervision
  final List<String> hazards;       // ["High heat", "Ocular laser exposure"]
  final String childSafeAlternative;// "Use Red LED instead of Laser Module"
  final bool requiresParentUnlock;
}
```

### 2.3 Project & Build Phase Model
```dart
class Project {
  final String id;                  // e.g. "proj_04"
  final String title;               // e.g. "Smart MONSTER Door"
  final String tagline;             // "Build an electronic passcode lock!"
  final DifficultyTier tier;        // builder
  final int estimatedMinutes;       // e.g. 45
  final List<String> requiredComponents;
  final List<String> prerequisiteLessons;
  final List<BuildPhase> phases;
  final TroubleshootingGuide troubleshooting;
  final int xpReward;               // e.g. 350
  final String badgeRewardId;       // "badge_door_master"
}

enum PhaseType { gatherParts, breadboardWiring, wiringCheck, codeReview, uploadSketch, physicalTest, debugTuning, missionComplete }

class BuildPhase {
  final int phaseNumber;
  final String phaseTitle;
  final PhaseType type;
  final String instructions;
  final String? diagramAsset;
  final String? inoSketchPath;       // e.g. "Projects/Smart MONSTER Door/Code/Source_Code_2/..."
  final Map<String, String>? expectedPins;
  final List<String> verificationCheckpoints;
}
```

---

## 3. Evaluation & Challenge Entities

### 3.1 Challenge Model
```dart
class Challenge {
  final String id;                  // e.g. "chal_pot_01"
  final String title;               // e.g. "Dim the RGB LED"
  final ChallengeType type;         // identifyPart, predictOutput, fixWiring, changeCode, debugLogic
  final DifficultyTier difficulty;
  final String prompt;
  final Map<String, dynamic> challengeData; // Circuit definition, buggy code snippet, or wiring matrix
  final String hint;
  final Map<String, dynamic> solutionValidation;
  final int xpAward;
}
```

### 3.2 Quiz Model
```dart
class Quiz {
  final String quizId;
  final String title;
  final List<QuizQuestion> questions;
  final int passingScorePercent;    // Default 75%
  final int xpReward;
}

class QuizQuestion {
  final String questionText;
  final String? imageAsset;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;         // Why this answer is right
}
```

---

## 4. Learner Profile & Progress Entities

### 4.1 Learner Profile Model
```dart
class LearnerProfile {
  final String id;                  // UUID v4
  final String nickname;            // e.g. "CyberBot"
  final String avatarId;            // e.g. "avatar_monster_bolt"
  final AgeBracket ageBracket;      // ages7_9, ages10_12, ages13Plus
  final DateTime createdAt;
  final DateTime lastActiveAt;
  final ProfileSettings settings;
}

class ProfileSettings {
  final bool soundEffectsEnabled;
  final bool voiceNarrationEnabled;
  final double textScalingFactor;
  final bool highContrastMode;
}
```

### 4.2 Progress & Reward Model
```dart
class LearnerProgress {
  final String learnerId;
  final int totalXp;
  final int currentLevel;           // Derived from XP (Level = floor(sqrt(XP / 50)) + 1)
  final Set<String> completedLessonIds;
  final Set<String> discoveredComponentIds;
  final Set<String> completedProjectIds;
  final Map<String, int> projectStepBookmarks; // Maps projectId -> highest completed phaseNumber
  final Set<String> solvedChallengeIds;
  final Set<String> earnedBadgeIds;
  final Map<String, int> quizBestScores;       // Maps quizId -> score percentage
  final DateTime lastSessionDate;
}

class Badge {
  final String id;
  final String name;                // e.g. "Ultrasonic Scout"
  final String description;         // "Built your first distance scanner"
  final String iconAsset;
  final BadgeCategory category;     // lesson, part, project, challenge, streak
  final DateTime? dateUnlocked;
}
```
