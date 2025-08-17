import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data_provider.dart';
import 'topic_checklist_screen.dart';
import 'reminders_screen.dart';
import 'progress_screen.dart';
import 'study_goals_screen.dart';
import 'study_schedule_screen.dart';
import 'mock_tests_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE3F2FD),
              Color(0xFFBBDEFB),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with welcome message
                _buildHeader(context),
                const SizedBox(height: 30),
                
                // Progress overview card
                _buildProgressCard(context),
                const SizedBox(height: 30),
                
                // Quick stats
                _buildQuickStats(context),
                const SizedBox(height: 30),
                
                // Main menu grid
                Expanded(child: _buildMenuGrid(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.medical_services,
                size: 32,
                color: Color(0xFF2196F3),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Ruchi!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'NEET PG Preparation Tracker',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return Consumer<AppDataProvider>(
      builder: (context, provider, child) {
        final progress = provider.overallProgress;
        final progressPercentage = (progress * 100).round();
        
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Overall Progress',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '$progressPercentage%',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2196F3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Study Streak',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Color(0xFFFF6B35),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${provider.studyStreak} days',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFF6B35),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Consumer<AppDataProvider>(
      builder: (context, provider, child) {
        final pendingReminders = provider.reminders.where((r) => !r.completed).length;
        final pendingGoals = provider.studyGoals.where((g) => !g.completed).length;
        final todaySchedule = provider.scheduleItems.where((s) => 
          s.day == _getDayName(DateTime.now().weekday)
        ).length;
        
        return Row(
          children: [
            Expanded(child: _buildStatCard(
              context, 
              'Reminders', 
              '$pendingReminders pending',
              Icons.notifications_active,
              const Color(0xFFFF6B35),
            )),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard(
              context, 
              'Goals', 
              '$pendingGoals active',
              Icons.flag,
              const Color(0xFF4CAF50),
            )),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard(
              context, 
              'Today', 
              '$todaySchedule tasks',
              Icons.schedule,
              const Color(0xFF9C27B0),
            )),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final menuItems = [
      {
        'title': 'Topic Checklist',
        'icon': Icons.checklist,
        'color': const Color(0xFF2196F3),
        'screen': const TopicChecklistScreen(),
      },
      {
        'title': 'Mock Tests',
        'icon': Icons.quiz,
        'color': const Color(0xFF4CAF50),
        'screen': const MockTestsScreen(),
      },
      {
        'title': 'Reminders',
        'icon': Icons.notifications,
        'color': const Color(0xFFFF6B35),
        'screen': const RemindersScreen(),
      },
      {
        'title': 'Progress Tracker',
        'icon': Icons.trending_up,
        'color': const Color(0xFF9C27B0),
        'screen': const ProgressScreen(),
      },
      {
        'title': 'Study Goals',
        'icon': Icons.flag,
        'color': const Color(0xFFFF9800),
        'screen': const StudyGoalsScreen(),
      },
      {
        'title': 'Study Schedule',
        'icon': Icons.schedule,
        'color': const Color(0xFF607D8B),
        'screen': const StudyScheduleScreen(),
      },
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _buildMenuItem(context, item);
      },
    );
  }

  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item['screen']),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: item['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                item['icon'],
                color: item['color'],
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item['title'],
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return 'Monday';
    }
  }
}
