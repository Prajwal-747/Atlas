import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/widgets/app_page_scaffold.dart';
import 'package:frontend/features/timetable/data/repositories/api_timetable_repository.dart';
import 'package:frontend/features/subjects/data/repositories/api_subject_repository.dart';
import 'package:frontend/features/subjects/domain/entities/subject.dart';
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
  final ApiTimetableRepository timetableRepository = ApiTimetableRepository();
  final ApiSubjectRepository subjectRepository = ApiSubjectRepository();
  List<Subject> subjects = [];
  Subject? selectedSubject;
  DayOfWeek selectedDay = DayOfWeek.monday;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    try {
      final loadedSubjects = await subjectRepository.getAllSubjects();
      if (!mounted) return;
      setState(() {
        subjects = loadedSubjects;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load subjects: $e')));
    }
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
    if (selectedSubject == null ||
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
      id: '',
      subjectId: selectedSubject!.id,
      subjectName: selectedSubject!.name,
      dayOfWeek: selectedDay,
      startTime: start,
      endTime: end,
    );
    try {
      await timetableRepository.addSession(session);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save class: $e')));
    }
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
          DropdownButtonFormField<Subject>(
            initialValue: selectedSubject,
            decoration: const InputDecoration(
              labelText: 'Subject',
              border: OutlineInputBorder(),
            ),
            items: subjects.map((subject) {
              return DropdownMenuItem(
                value: subject,
                child: Text('${subject.code} - ${subject.name}'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSubject = value;
              });
            },
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
