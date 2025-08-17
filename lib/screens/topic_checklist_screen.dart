import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data_provider.dart';
import '../models/topic.dart';

class TopicChecklistScreen extends StatelessWidget {
  const TopicChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topic Checklist'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Progress overview
              _buildProgressOverview(context, provider),
              
              // Topics list
              Expanded(
                child: _buildTopicsList(context, provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressOverview(BuildContext context, AppDataProvider provider) {
    final progress = provider.overallProgress;
    final progressPercentage = (progress * 100).round();
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Progress',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$progressPercentage%',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          Text(
            'Keep going! You\'re doing great!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicsList(BuildContext context, AppDataProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: provider.topics.length,
      itemBuilder: (context, index) {
        final topic = provider.topics[index];
        return _buildTopicCard(context, topic, provider);
      },
    );
  }

  Widget _buildTopicCard(BuildContext context, Topic topic, AppDataProvider provider) {
    final subtopicProgress = topic.progressPercentage;
    final subtopicProgressPercentage = (subtopicProgress * 100).round();
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Checkbox(
          value: topic.isCompleted,
          onChanged: (value) {
            if (value != null) {
              provider.toggleTopic(topic.name, value);
            }
          },
          activeColor: const Color(0xFF2196F3),
        ),
        title: Text(
          topic.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: topic.isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: topic.subtopics.isNotEmpty
            ? Text(
                'Subtopics: $subtopicProgressPercentage% complete',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              )
            : null,
        trailing: topic.subtopics.isNotEmpty
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getProgressColor(subtopicProgress),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$subtopicProgressPercentage%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
        children: topic.subtopics.map((subtopic) {
          final isCompleted = topic.subtopicProgress[subtopic] ?? false;
          return _buildSubtopicTile(context, topic.name, subtopic, isCompleted, provider);
        }).toList(),
      ),
    );
  }

  Widget _buildSubtopicTile(
    BuildContext context,
    String topicName,
    String subtopicName,
    bool isCompleted,
    AppDataProvider provider,
  ) {
    return ListTile(
      leading: Checkbox(
        value: isCompleted,
        onChanged: (value) {
          if (value != null) {
            provider.toggleSubtopic(topicName, subtopicName, value);
          }
        },
        activeColor: const Color(0xFF4CAF50),
      ),
      title: Text(
        subtopicName,
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
          color: isCompleted ? Colors.grey : Colors.black87,
        ),
      ),
      trailing: isCompleted
          ? const Icon(
              Icons.check_circle,
              color: Color(0xFF4CAF50),
              size: 20,
            )
          : null,
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.8) return const Color(0xFF4CAF50);
    if (progress >= 0.6) return const Color(0xFFFF9800);
    if (progress >= 0.4) return const Color(0xFFFFC107);
    return const Color(0xFFF44336);
  }
}
