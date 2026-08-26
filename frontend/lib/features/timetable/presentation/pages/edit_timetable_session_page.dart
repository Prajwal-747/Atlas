import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_page_scaffold.dart';
import 'package:frontend/features/subjects/domain/entities/subject.dart';
import 'package:frontend/features/timetable/data/repositories/api_timetable_repository.dart';
import 'package:frontend/features/timetable/domain/entities/class_session.dart';
import 'package:frontend/features/timetable/domain/entities/day_of_week.dart';
import 'package:frontend/features/timetable/domain/entities/time_of_day_model.dart';
import 'package:frontend/features/timetable/presentation/widgets/timetable_session_form.dart';

class EditTimetableSessionPage extends StatefulWidget {
  final ClassSession session;
  const EditTimetableSessionPage({super.key, required this.session});

  @override
  State<EditTimetableSessionPage> createState() =>
      _EditTimetableSessionPageState();
}

class _EditTimetableSessionPageState extends State<EditTimetableSessionPage> {
  final ApiTimetableRepository timetableRepository = ApiTimetableRepository();
  bool isSaving = false;
  Future<void> _updateSession({
    required Subject subject,
    required DayOfWeek day,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  }) async {
    setState(() {
      isSaving = true;
    });
    final updatedSession = ClassSession(
      id: widget.session.id,
      subjectId: subject.id,
      subjectName: subject.name,
      dayOfWeek: day,
      startTime: TimeOfDayModel(hour: startTime.hour, minute: startTime.minute),
      endTime: TimeOfDayModel(hour: endTime.hour, minute: endTime.minute),
    );
    try {
      await timetableRepository.updateSession(updatedSession);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update class: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Edit Class',
      child: TimetableSessionForm(
        initialSubjectId: widget.session.subjectId,
        initialDay: widget.session.dayOfWeek,
        initialStartTime: TimeOfDay(
          hour: widget.session.startTime.hour,
          minute: widget.session.startTime.minute,
        ),
        initialEndTime: TimeOfDay(
          hour: widget.session.endTime.hour,
          minute: widget.session.endTime.minute,
        ),
        buttonText: 'Save Changes',
        isSaving: isSaving,
        onSubmit: _updateSession,
      ),
    );
  }
}
