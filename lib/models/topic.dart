class Topic {
  final String name;
  final List<String> subtopics;
  final bool isCompleted;
  final Map<String, bool> subtopicProgress;

  Topic({
    required this.name,
    required this.subtopics,
    this.isCompleted = false,
    Map<String, bool>? subtopicProgress,
  }) : subtopicProgress = subtopicProgress ?? {};

  Topic copyWith({
    String? name,
    List<String>? subtopics,
    bool? isCompleted,
    Map<String, bool>? subtopicProgress,
  }) {
    return Topic(
      name: name ?? this.name,
      subtopics: subtopics ?? this.subtopics,
      isCompleted: isCompleted ?? this.isCompleted,
      subtopicProgress: subtopicProgress ?? this.subtopicProgress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'subtopics': subtopics,
      'isCompleted': isCompleted,
      'subtopicProgress': subtopicProgress,
    };
  }

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      name: json['name'] ?? '',
      subtopics: List<String>.from(json['subtopics'] ?? []),
      isCompleted: json['isCompleted'] ?? false,
      subtopicProgress: Map<String, bool>.from(json['subtopicProgress'] ?? {}),
    );
  }

  double get progressPercentage {
    if (subtopics.isEmpty) return isCompleted ? 1.0 : 0.0;
    
    int completedSubtopicCount = subtopicProgress.values.where((completed) => completed).length;
    return completedSubtopicCount / subtopics.length;
  }

  bool get allSubtopicsCompleted {
    if (subtopics.isEmpty) return isCompleted;
    return subtopicProgress.values.every((completed) => completed);
  }
}
