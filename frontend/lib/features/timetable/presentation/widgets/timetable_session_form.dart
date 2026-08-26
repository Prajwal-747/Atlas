import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/features/subjects/data/repositories/api_subject_repository.dart';
import 'package:frontend/features/subjects/domain/entities/subject.dart';
import 'package:frontend/features/timetable/domain/entities/day_of_week.dart';

class TimetableSessionForm extends StatefulWidget {
  final Subject? initialSubject;
  final String? initialSubjectId;
  final DayOfWeek initialDay;
  final TimeOfDay? initialStartTime;
  final TimeOfDay? initialEndTime;
  final String buttonText;
  final bool isSaving;
  final Future<void> Function({
    required Subject subject,
    required DayOfWeek day,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  })
  onSubmit;

  const TimetableSessionForm({
    super.key,
    this.initialSubject,
    this.initialSubjectId,
    this.initialDay = DayOfWeek.monday,
    this.initialStartTime,
    this.initialEndTime,
    required this.buttonText,
    required this.isSaving,
    required this.onSubmit,
  });

  @override
  State<TimetableSessionForm> createState() => _TimetableSessionFormState();
}

class _TimetableSessionFormState extends State<TimetableSessionForm> {
  final ApiSubjectRepository subjectRepository = ApiSubjectRepository();
  List<Subject> subjects = [];
  Subject? selectedSubject;
  late DayOfWeek selectedDay;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  @override
  void initState() {
    super.initState();
    selectedSubject = widget.initialSubject;
    selectedDay = widget.initialDay;
    selectedStartTime = widget.initialStartTime;
    selectedEndTime = widget.initialEndTime;
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    try {
      final loadedSubjects = await subjectRepository.getAllSubjects();
      if (!mounted) return;
      setState(() {
        subjects = loadedSubjects;
        if (widget.initialSubjectId != null) {
          for (final subject in loadedSubjects) {
            if (subject.id == widget.initialSubjectId) {
              selectedSubject = subject;
              break;
            }
          }
        } else if (selectedSubject != null) {
          for (final subject in loadedSubjects) {
            if (subject.id == selectedSubject!.id) {
              selectedSubject = subject;
              break;
            }
          }
        }
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

  Future<void> _submit() async {
    if (selectedSubject == null ||
        selectedStartTime == null ||
        selectedEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }
    final startMinutes =
        selectedStartTime!.hour * 60 + selectedStartTime!.minute;
    final endMinutes = selectedEndTime!.hour * 60 + selectedEndTime!.minute;

    if (endMinutes <= startMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time.')),
      );
      return;
    }
    await widget.onSubmit(
      subject: selectedSubject!,
      day: selectedDay,
      startTime: selectedStartTime!,
      endTime: selectedEndTime!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
          onPressed: widget.isSaving ? null : _submit,
          icon: widget.isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(),
                )
              : const Icon(Icons.save),
          label: Text(widget.isSaving ? 'Saving...' : widget.buttonText),
        ),
      ],
    );
  }
}
