class CourseModel {
  final String id;
  final String title;
  final String summary;
  final List<String> lessonIds;
  final bool isOptional;
  final String? placementLessonId;
  final List<String> prerequisites;
  final int xpReward;
  final int estimatedMinutes;

  const CourseModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.lessonIds,
    this.isOptional = false,
    this.placementLessonId,
    required this.prerequisites,
    required this.xpReward,
    required this.estimatedMinutes,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      lessonIds: List<String>.from(json['lessonIds'] as List),
      isOptional: json['isOptional'] as bool? ?? false,
      placementLessonId: json['placementLessonId'] as String?,
      prerequisites: List<String>.from(json['prerequisites'] as List),
      xpReward: json['xpReward'] as int,
      estimatedMinutes: json['estimatedMinutes'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'summary': summary,
        'lessonIds': lessonIds,
        'isOptional': isOptional,
        'placementLessonId': placementLessonId,
        'prerequisites': prerequisites,
        'xpReward': xpReward,
        'estimatedMinutes': estimatedMinutes,
      };
}
