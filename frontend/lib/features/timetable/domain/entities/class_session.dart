import 'day_of_week.dart';
import 'time_of_day_model.dart';

class ClassSession {
  final String id;
  final String subjectId;
  final String subjectName;

  final DayOfWeek dayOfWeek;

  final TimeOfDayModel startTime;
  final TimeOfDayModel endTime;

  const ClassSession({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });
}
