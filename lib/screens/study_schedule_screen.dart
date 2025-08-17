import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data_provider.dart';
import '../models/schedule_item.dart';

class StudyScheduleScreen extends StatefulWidget {
  const StudyScheduleScreen({super.key});

  @override
  State<StudyScheduleScreen> createState() => _StudyScheduleScreenState();
}

class _StudyScheduleScreenState extends State<StudyScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _timeController = TextEditingController();
  final _topicController = TextEditingController();
  String _selectedDay = 'Monday';

  final List<String> _days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
    'Friday', 'Saturday', 'Sunday'
  ];

  @override
  void dispose() {
    _timeController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Schedule'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Summary card
              _buildSummaryCard(context, provider),
              
              // Schedule list
              Expanded(
                child: _buildScheduleList(context, provider),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddScheduleDialog(context),
        backgroundColor: const Color(0xFF607D8B),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, AppDataProvider provider) {
    final totalItems = provider.scheduleItems.length;
    final todayItems = provider.scheduleItems.where((s) => 
      s.day == _getDayName(DateTime.now().weekday)
    ).length;
    final weekItems = provider.scheduleItems.length;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF607D8B), Color(0xFF455A64)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(context, 'Today', '$todayItems', Icons.today),
          _buildSummaryItem(context, 'This Week', '$weekItems', Icons.view_week),
          _buildSummaryItem(context, 'Total', '$totalItems', Icons.schedule),
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

  Widget _buildScheduleList(BuildContext context, AppDataProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _days.length,
      itemBuilder: (context, index) {
        final day = _days[index];
        final daySchedule = provider.getScheduleForDay(day);
        return _buildDayScheduleCard(context, day, daySchedule, provider);
      },
    );
  }

  Widget _buildDayScheduleCard(BuildContext context, String day, List<ScheduleItem> schedule, AppDataProvider provider) {
    final isToday = day == _getDayName(DateTime.now().weekday);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isToday ? const Color(0xFF607D8B) : Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.calendar_today,
            color: isToday ? Colors.white : Colors.grey[600],
            size: 20,
          ),
        ),
        title: Text(
          day,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isToday ? const Color(0xFF607D8B) : Colors.black87,
          ),
        ),
        subtitle: Text(
          '${schedule.length} task${schedule.length == 1 ? '' : 's'} scheduled',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isToday)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF607D8B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'TODAY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddScheduleDialog(context, day),
              color: const Color(0xFF607D8B),
            ),
          ],
        ),
        children: schedule.isEmpty 
            ? [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No schedule set for this day',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ]
            : schedule.map((item) => _buildScheduleItem(context, item, provider)).toList(),
      ),
    );
  }

  Widget _buildScheduleItem(BuildContext context, ScheduleItem item, AppDataProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF607D8B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.access_time,
              color: const Color(0xFF607D8B),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.topic,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Time: ${item.time}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteDialog(context, item, provider),
          ),
        ],
      ),
    );
  }

  void _showAddScheduleDialog(BuildContext context, [String? day]) {
    _timeController.clear();
    _topicController.clear();
    _selectedDay = day ?? _getDayName(DateTime.now().weekday);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Schedule for $_selectedDay'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  hintText: 'HH:MM (e.g., 09:00)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter time';
                  }
                  if (!RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$').hasMatch(value)) {
                    return 'Please enter valid time (HH:MM)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _topicController,
                decoration: const InputDecoration(
                  labelText: 'Topic/Activity',
                  hintText: 'Enter what you will study',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter topic/activity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Day'),
                subtitle: Text(_selectedDay),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: () => _showDayPicker(context),
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
                final scheduleItem = ScheduleItem(
                  id: provider.generateId(),
                  time: _timeController.text.trim(),
                  topic: _topicController.text.trim(),
                  day: _selectedDay,
                );
                provider.addScheduleItem(scheduleItem);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showDayPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Day'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _days.map((day) {
            return ListTile(
              title: Text(day),
              trailing: _selectedDay == day ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                setState(() => _selectedDay = day);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ScheduleItem item, AppDataProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Schedule Item'),
        content: Text('Are you sure you want to delete "${item.topic}" from ${item.day}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteScheduleItem(item.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
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
