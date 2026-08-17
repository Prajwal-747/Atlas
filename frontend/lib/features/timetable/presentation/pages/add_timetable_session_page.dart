import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/widgets/app_page_scaffold.dart';
import 'package:frontend/features/timetable/data/repositories/mock_timetable_repository.dart';
import 'package:frontend/features/timetable/domain/entities/class_session.dart';
import 'package:frontend/features/timetable/domain/entities/day_of_week.dart';
import 'package:frontend/features/timetable/domain/entities/time_of_day_model.dart';

class AddTimetableSessionPage extends StatefulWidget {
  const AddTimetableSessionPage({super.key});
  @override
  State<AddTimetableSessionPage> createState() =>
      _AddTimetableSessionPageState();
}

class _AddTimetableSessionPageState extends State<AddTimetableSessionPage> {
  final MockTimetableRepository timetableRepository = MockTimetableRepository();
  final subjectIdController = TextEditingController();
  final subjectNameController = TextEditingController();
  DayOfWeek selectedDay = DayOfWeek.monday;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  @override
  void dispose() {
    subjectIdController.dispose();
    subjectNameController.dispose();
    super.dispose();
  }

  Future<void> _selectStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() {
        selectedStartTime = picked;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime ?? const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null) {
      setState(() {
        selectedEndTime = picked;
      });
    }
  }

  Future<void> _saveSession() async {
    if (subjectIdController.text.trim().isEmpty ||
        subjectNameController.text.trim().isEmpty ||
        selectedStartTime == null ||
        selectedEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }
    final start = TimeOfDayModel(
      hour: selectedStartTime!.hour,
      minute: selectedStartTime!.minute,
    );
    final end = TimeOfDayModel(
      hour: selectedEndTime!.hour,
      minute: selectedEndTime!.minute,
    );
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    if (endMinutes <= startMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time.')),
      );
      return;
    }
    final session = ClassSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      subjectId: subjectIdController.text.trim(),
      subjectName: subjectNameController.text.trim(),
      dayOfWeek: selectedDay,
      startTime: start,
      endTime: end,
    );
    await timetableRepository.addSession(session);
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  String _dayText(DayOfWeek day) {
    switch (day) {
      case DayOfWeek.monday:
        return 'Monday';
      case DayOfWeek.tuesday:
        return 'Tuesday';
      case DayOfWeek.wednesday:
        return 'Wednesday';
      case DayOfWeek.thursday:
        return 'Thursday';
      case DayOfWeek.friday:
        return 'Friday';
      case DayOfWeek.saturday:
        return 'Saturday';
      case DayOfWeek.sunday:
        return 'Sunday';
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) {
      return 'Select time';
    }
    return time.format(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Add Class',
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          TextField(
            controller: subjectIdController,
            decoration: const InputDecoration(
              labelText: 'Subject ID',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: subjectNameController,
            decoration: const InputDecoration(
              labelText: 'Subject Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<DayOfWeek>(
            initialValue: selectedDay,
            decoration: const InputDecoration(
              labelText: 'Day',
              border: OutlineInputBorder(),
            ),
            items: DayOfWeek.values.map((day) {
              return DropdownMenuItem(value: day, child: Text(_dayText(day)));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedDay = value;
                });
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Start Time'),
            subtitle: Text(_formatTime(selectedStartTime)),
            trailing: const Icon(Icons.access_time),
            onTap: _selectStartTime,
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('End Time'),
            subtitle: Text(_formatTime(selectedEndTime)),
            trailing: const Icon(Icons.access_time),
            onTap: _selectEndTime,
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: _saveSession,
            label: const Text('Save Class'),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}
