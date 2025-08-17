class ScheduleItem {
  final String id;
  final String time;
  final String topic;
  final String day;

  ScheduleItem({
    required this.id,
    required this.time,
    required this.topic,
    required this.day,
  });

  ScheduleItem copyWith({
    String? id,
    String? time,
    String? topic,
    String? day,
  }) {
    return ScheduleItem(
      id: id ?? this.id,
      time: time ?? this.time,
      topic: topic ?? this.topic,
      day: day ?? this.day,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'topic': topic,
      'day': day,
    };
  }

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      id: json['id'] ?? '',
      time: json['time'] ?? '',
      topic: json['topic'] ?? '',
      day: json['day'] ?? '',
    );
  }

  DateTime get timeAsDateTime {
    final timeParts = time.split(':');
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  }

  String get formattedTime {
    return time;
  }
}
