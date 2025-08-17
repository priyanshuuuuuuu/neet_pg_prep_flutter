class MockTest {
  final String id;
  final String name;
  final DateTime date;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final int unattempted;
  final double score;
  final String subject;
  final String notes;

  MockTest({
    required this.id,
    required this.name,
    required this.date,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.unattempted,
    required this.score,
    required this.subject,
    this.notes = '',
  });

  MockTest copyWith({
    String? id,
    String? name,
    DateTime? date,
    int? totalQuestions,
    int? correctAnswers,
    int? incorrectAnswers,
    int? unattempted,
    double? score,
    String? subject,
    String? notes,
  }) {
    return MockTest(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      unattempted: unattempted ?? this.unattempted,
      score: score ?? this.score,
      subject: subject ?? this.subject,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'incorrectAnswers': incorrectAnswers,
      'unattempted': unattempted,
      'score': score,
      'subject': subject,
      'notes': notes,
    };
  }

  factory MockTest.fromJson(Map<String, dynamic> json) {
    final dateParts = (json['date'] as String).split('/');
    
    return MockTest(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      date: DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
      ),
      totalQuestions: json['totalQuestions'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      incorrectAnswers: json['incorrectAnswers'] ?? 0,
      unattempted: json['unattempted'] ?? 0,
      score: (json['score'] ?? 0.0).toDouble(),
      subject: json['subject'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  double get accuracy {
    if (totalQuestions == 0) return 0.0;
    return (correctAnswers / totalQuestions) * 100;
  }

  String get performance {
    if (score >= 80) return 'Excellent';
    if (score >= 70) return 'Good';
    if (score >= 60) return 'Average';
    if (score >= 50) return 'Below Average';
    return 'Poor';
  }

  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
