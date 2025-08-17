import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/topic.dart';
import '../models/reminder.dart';
import '../models/study_goal.dart';
import '../models/schedule_item.dart';
import '../models/mock_test.dart';

class AppDataProvider extends ChangeNotifier {
  List<Topic> _topics = [];
  List<Reminder> _reminders = [];
  List<StudyGoal> _studyGoals = [];
  List<ScheduleItem> _scheduleItems = [];
  List<MockTest> _mockTests = [];
  int _studyStreak = 0;
  DateTime? _lastStudyDate;

  // Getters
  List<Topic> get topics => _topics;
  List<Reminder> get reminders => _reminders;
  List<StudyGoal> get studyGoals => _studyGoals;
  List<ScheduleItem> get scheduleItems => _scheduleItems;
  List<MockTest> get mockTests => _mockTests;
  int get studyStreak => _studyStreak;
  DateTime? get lastStudyDate => _lastStudyDate;

  // Initialize topics with medical subjects
  void initializeTopics() {
    if (_topics.isEmpty) {
      _topics = [
        Topic(
          name: "Anatomy",
          subtopics: [
            "General Anatomy", "Upper Limb", "Lower Limb", "Thorax", "Abdomen", 
            "Head & Neck", "Neuroanatomy", "Embryology"
          ],
        ),
        Topic(
          name: "Physiology",
          subtopics: [
            "General Physiology", "Blood", "Cardiovascular", "Respiratory", 
            "Gastrointestinal", "Endocrine", "Nervous System", "Renal"
          ],
        ),
        Topic(
          name: "Biochemistry",
          subtopics: [
            "Cell Biology", "Carbohydrates", "Proteins", "Lipids", 
            "Nucleic Acids", "Enzymes", "Metabolism", "Clinical Biochemistry"
          ],
        ),
        Topic(
          name: "Pathology",
          subtopics: [
            "General Pathology", "Cardiovascular", "Respiratory", "Gastrointestinal",
            "Hematology", "Endocrine", "Nervous System", "Musculoskeletal"
          ],
        ),
        Topic(
          name: "Microbiology",
          subtopics: [
            "Bacteriology", "Virology", "Mycology", "Parasitology",
            "Immunology", "Clinical Microbiology"
          ],
        ),
        Topic(
          name: "Pharmacology",
          subtopics: [
            "General Pharmacology", "Autonomic Drugs", "Cardiovascular Drugs",
            "CNS Drugs", "Chemotherapy", "Clinical Pharmacology"
          ],
        ),
        Topic(
          name: "Forensic Medicine",
          subtopics: [
            "Medicolegal Aspects", "Postmortem", "Injuries", "Toxicology",
            "Medical Ethics", "Laws"
          ],
        ),
        Topic(
          name: "Community Medicine",
          subtopics: [
            "Epidemiology", "Biostatistics", "Nutrition", "MCH",
            "Communicable Diseases", "Non-communicable Diseases"
          ],
        ),
      ];
    }
  }

  // Overall progress calculation
  double get overallProgress {
    if (_topics.isEmpty) return 0.0;
    
    int totalItems = 0;
    int completedItems = 0;
    
    for (var topic in _topics) {
      if (topic.subtopics.isEmpty) {
        totalItems++;
        if (topic.isCompleted) completedItems++;
      } else {
        totalItems += topic.subtopics.length;
        completedItems += topic.subtopicProgress.values.where((completed) => completed).length;
      }
    }
    
    return totalItems > 0 ? completedItems / totalItems : 0.0;
  }

  // Topic management
  void toggleTopic(String topicName, bool value) {
    final topicIndex = _topics.indexWhere((t) => t.name == topicName);
    if (topicIndex != -1) {
      _topics[topicIndex] = _topics[topicIndex].copyWith(isCompleted: value);
      _saveTopics();
      _updateStudyStreak();
      notifyListeners();
    }
  }

  void toggleSubtopic(String topicName, String subtopicName, bool value) {
    final topicIndex = _topics.indexWhere((t) => t.name == topicName);
    if (topicIndex != -1) {
      final topic = _topics[topicIndex];
      final updatedSubtopicProgress = Map<String, bool>.from(topic.subtopicProgress);
      updatedSubtopicProgress[subtopicName] = value;
      
      _topics[topicIndex] = topic.copyWith(subtopicProgress: updatedSubtopicProgress);
      _saveTopics();
      _updateStudyStreak();
      notifyListeners();
    }
  }

  // Reminder management
  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    _saveReminders();
    notifyListeners();
  }

  void toggleReminder(String reminderId) {
    final reminderIndex = _reminders.indexWhere((r) => r.id == reminderId);
    if (reminderIndex != -1) {
      _reminders[reminderIndex] = _reminders[reminderIndex].copyWith(
        completed: !_reminders[reminderIndex].completed,
      );
      _saveReminders();
      notifyListeners();
    }
  }

  void deleteReminder(String reminderId) {
    _reminders.removeWhere((r) => r.id == reminderId);
    _saveReminders();
    notifyListeners();
  }

  // Study goal management
  void addStudyGoal(StudyGoal goal) {
    _studyGoals.add(goal);
    _saveStudyGoals();
    notifyListeners();
  }

  void toggleStudyGoal(String goalId) {
    final goalIndex = _studyGoals.indexWhere((g) => g.id == goalId);
    if (goalIndex != -1) {
      _studyGoals[goalIndex] = _studyGoals[goalIndex].copyWith(
        completed: !_studyGoals[goalIndex].completed,
      );
      _saveStudyGoals();
      _updateStudyStreak();
      notifyListeners();
    }
  }

  void deleteStudyGoal(String goalId) {
    _studyGoals.removeWhere((g) => g.id == goalId);
    _saveStudyGoals();
    notifyListeners();
  }

  // Schedule management
  void addScheduleItem(ScheduleItem item) {
    _scheduleItems.add(item);
    _scheduleItems.sort((a, b) => a.timeAsDateTime.compareTo(b.timeAsDateTime));
    _saveSchedule();
    notifyListeners();
  }

  void deleteScheduleItem(String itemId) {
    _scheduleItems.removeWhere((item) => item.id == itemId);
    _saveSchedule();
    notifyListeners();
  }

  List<ScheduleItem> getScheduleForDay(String day) {
    return _scheduleItems.where((item) => item.day == day).toList();
  }

  // Mock test management
  void addMockTest(MockTest test) {
    _mockTests.add(test);
    _mockTests.sort((a, b) => b.date.compareTo(a.date));
    _saveMockTests();
    _updateStudyStreak();
    notifyListeners();
  }

  void deleteMockTest(String testId) {
    _mockTests.removeWhere((test) => test.id == testId);
    _saveMockTests();
    notifyListeners();
  }

  // Study streak management
  void _updateStudyStreak() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    
    if (_lastStudyDate == null) {
      _lastStudyDate = todayDate;
      _studyStreak = 1;
    } else {
      final lastDate = DateTime(_lastStudyDate!.year, _lastStudyDate!.month, _lastStudyDate!.day);
      final difference = todayDate.difference(lastDate).inDays;
      
      if (difference == 1) {
        _studyStreak++;
        _lastStudyDate = todayDate;
      } else if (difference > 1) {
        _studyStreak = 1;
        _lastStudyDate = todayDate;
      }
    }
    
    _saveStudyStreak();
  }

  // Data persistence methods
  Future<void> loadAllData() async {
    await Future.wait([
      _loadTopics(),
      _loadReminders(),
      _loadStudyGoals(),
      _loadSchedule(),
      _loadMockTests(),
      _loadStudyStreak(),
    ]);
    initializeTopics();
    notifyListeners();
  }

  Future<void> _saveTopics() async {
    final prefs = await SharedPreferences.getInstance();
    final topicsJson = _topics.map((t) => t.toJson()).toList();
    await prefs.setString('topics', jsonEncode(topicsJson));
  }

  Future<void> _loadTopics() async {
    final prefs = await SharedPreferences.getInstance();
    final topicsString = prefs.getString('topics');
    if (topicsString != null) {
      final topicsJson = jsonDecode(topicsString) as List;
      _topics = topicsJson.map((json) => Topic.fromJson(json)).toList();
    }
  }

  Future<void> _saveReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final remindersJson = _reminders.map((r) => r.toJson()).toList();
    await prefs.setString('reminders', jsonEncode(remindersJson));
  }

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final remindersString = prefs.getString('reminders');
    if (remindersString != null) {
      final remindersJson = jsonDecode(remindersString) as List;
      _reminders = remindersJson.map((json) => Reminder.fromJson(json)).toList();
    }
  }

  Future<void> _saveStudyGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final goalsJson = _studyGoals.map((g) => g.toJson()).toList();
    await prefs.setString('studyGoals', jsonEncode(goalsJson));
  }

  Future<void> _loadStudyGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final goalsString = prefs.getString('studyGoals');
    if (goalsString != null) {
      final goalsJson = jsonDecode(goalsString) as List;
      _studyGoals = goalsJson.map((json) => StudyGoal.fromJson(json)).toList();
    }
  }

  Future<void> _saveSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduleJson = _scheduleItems.map((s) => s.toJson()).toList();
    await prefs.setString('schedule', jsonEncode(scheduleJson));
  }

  Future<void> _loadSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduleString = prefs.getString('schedule');
    if (scheduleString != null) {
      final scheduleJson = jsonDecode(scheduleString) as List;
      _scheduleItems = scheduleJson.map((json) => ScheduleItem.fromJson(json)).toList();
    }
  }

  Future<void> _saveMockTests() async {
    final prefs = await SharedPreferences.getInstance();
    final testsJson = _mockTests.map((t) => t.toJson()).toList();
    await prefs.setString('mockTests', jsonEncode(testsJson));
  }

  Future<void> _loadMockTests() async {
    final prefs = await SharedPreferences.getInstance();
    final testsString = prefs.getString('mockTests');
    if (testsString != null) {
      final testsJson = jsonDecode(testsString) as List;
      _mockTests = testsJson.map((json) => MockTest.fromJson(json)).toList();
    }
  }

  Future<void> _saveStudyStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('studyStreak', _studyStreak);
    if (_lastStudyDate != null) {
      await prefs.setString('lastStudyDate', _lastStudyDate!.toIso8601String());
    }
  }

  Future<void> _loadStudyStreak() async {
    final prefs = await SharedPreferences.getInstance();
    _studyStreak = prefs.getInt('studyStreak') ?? 0;
    final lastStudyDateString = prefs.getString('lastStudyDate');
    if (lastStudyDateString != null) {
      _lastStudyDate = DateTime.parse(lastStudyDateString);
    }
  }

  // Utility methods
  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void refreshAllData() {
    notifyListeners();
  }
}
