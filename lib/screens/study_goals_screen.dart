import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data_provider.dart';
import '../models/study_goal.dart';

class StudyGoalsScreen extends StatefulWidget {
  const StudyGoalsScreen({super.key});

  @override
  State<StudyGoalsScreen> createState() => _StudyGoalsScreenState();
}

class _StudyGoalsScreenState extends State<StudyGoalsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDeadline = DateTime.now().add(const Duration(days: 7));
  GoalPriority _selectedPriority = GoalPriority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Goals'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) {
          final goals = provider.studyGoals;
          final activeGoals = goals.where((g) => !g.completed).toList();
          final completedGoals = goals.where((g) => g.completed).toList();

          return Column(
            children: [
              // Summary card
              _buildSummaryCard(context, provider),
              
              // Goals list
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TabBar(
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey[600],
                          indicator: BoxDecoration(
                            color: const Color(0xFFFF9800),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          tabs: [
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.flag, size: 16),
                                  const SizedBox(width: 4),
                                  Text('Active (${activeGoals.length})'),
                                ],
                              ),
                            ),
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_circle, size: 16),
                                  const SizedBox(width: 4),
                                  Text('Completed (${completedGoals.length})'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildGoalsList(context, activeGoals, provider, false),
                            _buildGoalsList(context, completedGoals, provider, true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context),
        backgroundColor: const Color(0xFFFF9800),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, AppDataProvider provider) {
    final totalGoals = provider.studyGoals.length;
    final completedGoals = provider.studyGoals.where((g) => g.completed).length;
    final overdueGoals = provider.studyGoals.where((g) => g.isOverdue).length;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(context, 'Total', '$totalGoals', Icons.flag),
          _buildSummaryItem(context, 'Completed', '$completedGoals', Icons.check_circle),
          _buildSummaryItem(context, 'Overdue', '$overdueGoals', Icons.warning),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsList(BuildContext context, List<StudyGoal> goals, AppDataProvider provider, bool isCompleted) {
    if (goals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted ? Icons.check_circle_outline : Icons.flag_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isCompleted ? 'No completed goals' : 'No active goals',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final goal = goals[index];
        return _buildGoalCard(context, goal, provider);
      },
    );
  }

  Widget _buildGoalCard(BuildContext context, StudyGoal goal, AppDataProvider provider) {
    final isOverdue = goal.isOverdue;
    final daysUntilDeadline = goal.daysUntilDeadline;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: goal.completed 
                ? Colors.grey[300] 
                : _getPriorityColor(goal.priority).withOpacity(0.2),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            goal.completed ? Icons.check_circle : Icons.flag,
            color: goal.completed 
                ? Colors.grey[600] 
                : _getPriorityColor(goal.priority),
          ),
        ),
        title: Text(
          goal.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: goal.completed ? TextDecoration.lineThrough : null,
            color: goal.completed ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (goal.description.isNotEmpty) ...[
              Text(
                goal.description,
                style: TextStyle(
                  color: goal.completed ? Colors.grey : Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
            ],
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(goal.priority).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    goal.priorityText,
                    style: TextStyle(
                      color: _getPriorityColor(goal.priority),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: goal.completed ? Colors.grey : Colors.black54,
                ),
                const SizedBox(width: 4),
                Text(
                  '${goal.deadline.day.toString().padLeft(2, '0')}/${goal.deadline.month.toString().padLeft(2, '0')}/${goal.deadline.year}',
                  style: TextStyle(
                    color: goal.completed ? Colors.grey : Colors.black54,
                  ),
                ),
              ],
            ),
            if (isOverdue && !goal.completed) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'OVERDUE',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ] else if (!goal.completed && daysUntilDeadline <= 3) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Due in $daysUntilDeadline day${daysUntilDeadline == 1 ? '' : 's'}',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                goal.completed ? Icons.refresh : Icons.check,
                color: goal.completed ? Colors.orange : Colors.green,
              ),
              onPressed: () {
                provider.toggleStudyGoal(goal.id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(context, goal, provider),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    _titleController.clear();
    _descriptionController.clear();
    _selectedDeadline = DateTime.now().add(const Duration(days: 7));
    _selectedPriority = GoalPriority.medium;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Study Goal'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter goal title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Enter goal description',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Priority'),
                      subtitle: Text(_selectedPriority.name.toUpperCase()),
                      onTap: () => _showPriorityPicker(context),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Deadline'),
                      subtitle: Text(
                        '${_selectedDeadline.day.toString().padLeft(2, '0')}/${_selectedDeadline.month.toString().padLeft(2, '0')}/${_selectedDeadline.year}',
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDeadline,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() => _selectedDeadline = date);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final provider = context.read<AppDataProvider>();
                final goal = StudyGoal(
                  id: provider.generateId(),
                  title: _titleController.text.trim(),
                  description: _descriptionController.text.trim(),
                  deadline: _selectedDeadline,
                  priority: _selectedPriority,
                );
                provider.addStudyGoal(goal);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showPriorityPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Priority'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: GoalPriority.values.map((priority) {
            return ListTile(
              leading: Icon(
                Icons.flag,
                color: _getPriorityColor(priority),
              ),
              title: Text(priority.name.toUpperCase()),
              onTap: () {
                setState(() => _selectedPriority = priority);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, StudyGoal goal, AppDataProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Goal'),
        content: Text('Are you sure you want to delete "${goal.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteStudyGoal(goal.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(GoalPriority priority) {
    switch (priority) {
      case GoalPriority.high:
        return Colors.red;
      case GoalPriority.medium:
        return Colors.orange;
      case GoalPriority.low:
        return Colors.green;
    }
  }
}
