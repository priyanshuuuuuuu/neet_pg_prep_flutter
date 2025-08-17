class Reminder {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final String time;
  final bool completed;

  Reminder({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.time,
    this.completed = false,
  });

  Reminder copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? date,
    String? time,
    bool? completed,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      date: date ?? this.date,
      time: time ?? this.time,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'date': '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
      'time': time,
      'completed': completed,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    final dateParts = (json['date'] as String).split('/');
    
    return Reminder(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      date: DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
      ),
      time: json['time'] ?? '',
      completed: json['completed'] ?? false,
    );
  }

  bool get isOverdue {
    final now = DateTime.now();
    final reminderDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(time.split(':')[0]),
      int.parse(time.split(':')[1]),
    );
    return now.isAfter(reminderDateTime) && !completed;
  }
}
