enum GoalPriority { high, medium, low }

class StudyGoal {
  final String id;
  final String title;
  final String description;
  final DateTime deadline;
  final GoalPriority priority;
  final bool completed;

  StudyGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.priority,
    this.completed = false,
  });

  StudyGoal copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? deadline,
    GoalPriority? priority,
    bool? completed,
  }) {
    return StudyGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': '${deadline.day.toString().padLeft(2, '0')}/${deadline.month.toString().padLeft(2, '0')}/${deadline.year}',
      'priority': priority.name,
      'completed': completed,
    };
  }

  factory StudyGoal.fromJson(Map<String, dynamic> json) {
    final deadlineParts = (json['deadline'] as String).split('/');
    
    return StudyGoal(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      deadline: DateTime(
        int.parse(deadlineParts[2]),
        int.parse(deadlineParts[1]),
        int.parse(deadlineParts[0]),
      ),
      priority: GoalPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => GoalPriority.medium,
      ),
      completed: json['completed'] ?? false,
    );
  }

  bool get isOverdue {
    return DateTime.now().isAfter(deadline) && !completed;
  }

  int get daysUntilDeadline {
    final now = DateTime.now();
    final deadlineDate = DateTime(deadline.year, deadline.month, deadline.day);
    final today = DateTime(now.year, now.month, now.day);
    return deadlineDate.difference(today).inDays;
  }

  String get priorityText {
    switch (priority) {
      case GoalPriority.high:
        return 'High';
      case GoalPriority.medium:
        return 'Medium';
      case GoalPriority.low:
        return 'Low';
    }
  }

  int get priorityValue {
    switch (priority) {
      case GoalPriority.high:
        return 3;
      case GoalPriority.medium:
        return 2;
      case GoalPriority.low:
        return 1;
    }
  }
}
