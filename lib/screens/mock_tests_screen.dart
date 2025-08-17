import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data_provider.dart';
import '../models/mock_test.dart';

class MockTestsScreen extends StatefulWidget {
  const MockTestsScreen({super.key});

  @override
  State<MockTestsScreen> createState() => _MockTestsScreenState();
}

class _MockTestsScreenState extends State<MockTestsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _subjectController = TextEditingController();
  final _totalQuestionsController = TextEditingController();
  final _correctAnswersController = TextEditingController();
  final _incorrectAnswersController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _subjectController.dispose();
    _totalQuestionsController.dispose();
    _correctAnswersController.dispose();
    _incorrectAnswersController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock Tests'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) {
          final tests = provider.mockTests;
          
          return Column(
            children: [
              // Performance overview
              _buildPerformanceOverview(context, provider),
              
              // Tests list
              Expanded(
                child: tests.isEmpty 
                    ? _buildEmptyState(context)
                    : _buildTestsList(context, tests, provider),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTestDialog(context),
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPerformanceOverview(BuildContext context, AppDataProvider provider) {
    final tests = provider.mockTests;
    if (tests.isEmpty) return const SizedBox.shrink();
    
    final averageScore = tests.map((t) => t.score).reduce((a, b) => a + b) / tests.length;
    final bestScore = tests.map((t) => t.score).reduce((a, b) => a > b ? a : b);
    final totalTests = tests.length;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPerformanceStat(context, 'Average', '${averageScore.toStringAsFixed(1)}%', Icons.trending_up),
              _buildPerformanceStat(context, 'Best', '${bestScore.toStringAsFixed(1)}%', Icons.star),
              _buildPerformanceStat(context, 'Tests', '$totalTests', Icons.quiz),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: averageScore / 100,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            'Overall Performance: ${averageScore.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceStat(BuildContext context, String label, String value, IconData icon) {
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No mock tests yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first mock test to start tracking performance',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTestsList(BuildContext context, List<MockTest> tests, AppDataProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tests.length,
      itemBuilder: (context, index) {
        final test = tests[index];
        return _buildTestCard(context, test, provider);
      },
    );
  }

  Widget _buildTestCard(BuildContext context, MockTest test, AppDataProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getScoreColor(test.score).withOpacity(0.2),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            Icons.quiz,
            color: _getScoreColor(test.score),
          ),
        ),
        title: Text(
          test.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getScoreColor(test.score).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${test.score.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: _getScoreColor(test.score),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  test.performance,
                  style: TextStyle(
                    color: _getScoreColor(test.score),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.subject,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  test.subject,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  test.formattedDate,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Correct: ${test.correctAnswers}',
                  style: TextStyle(
                    color: Colors.green[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Incorrect: ${test.incorrectAnswers}',
                  style: TextStyle(
                    color: Colors.red[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (test.unattempted > 0) ...[
                  const SizedBox(width: 16),
                  Text(
                    'Unattempted: ${test.unattempted}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
            if (test.notes.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Notes: ${test.notes}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _showDeleteDialog(context, test, provider),
        ),
      ),
    );
  }

  void _showAddTestDialog(BuildContext context) {
    _nameController.clear();
    _subjectController.clear();
    _totalQuestionsController.clear();
    _correctAnswersController.clear();
    _incorrectAnswersController.clear();
    _notesController.clear();
    _selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Mock Test Result'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Test Name',
                    hintText: 'e.g., Full Length Test 1',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter test name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                    hintText: 'e.g., Anatomy, Physiology',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter subject';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _totalQuestionsController,
                        decoration: const InputDecoration(
                          labelText: 'Total Questions',
                          hintText: 'e.g., 200',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _correctAnswersController,
                        decoration: const InputDecoration(
                          labelText: 'Correct Answers',
                          hintText: 'e.g., 150',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _incorrectAnswersController,
                  decoration: const InputDecoration(
                    labelText: 'Incorrect Answers',
                    hintText: 'e.g., 30',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Invalid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Test Date'),
                  subtitle: Text(
                    '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _selectedDate = date);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (Optional)',
                    hintText: 'Any additional notes about the test',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
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
                final totalQuestions = int.parse(_totalQuestionsController.text);
                final correctAnswers = int.parse(_correctAnswersController.text);
                final incorrectAnswers = int.parse(_incorrectAnswersController.text);
                final unattempted = totalQuestions - correctAnswers - incorrectAnswers;
                
                if (unattempted < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Total questions must be greater than or equal to correct + incorrect answers'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                final score = (correctAnswers / totalQuestions) * 100;
                
                final provider = context.read<AppDataProvider>();
                final test = MockTest(
                  id: provider.generateId(),
                  name: _nameController.text.trim(),
                  date: _selectedDate,
                  totalQuestions: totalQuestions,
                  correctAnswers: correctAnswers,
                  incorrectAnswers: incorrectAnswers,
                  unattempted: unattempted,
                  score: score,
                  subject: _subjectController.text.trim(),
                  notes: _notesController.text.trim(),
                );
                provider.addMockTest(test);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, MockTest test, AppDataProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Mock Test'),
        content: Text('Are you sure you want to delete "${test.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteMockTest(test.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return const Color(0xFF4CAF50);
    if (score >= 70) return const Color(0xFF8BC34A);
    if (score >= 60) return const Color(0xFFFFC107);
    if (score >= 50) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }
}
