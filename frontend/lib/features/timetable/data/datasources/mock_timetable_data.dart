import '../../domain/entities/class_session.dart';
import '../../domain/entities/day_of_week.dart';
import '../../domain/entities/time_of_day_model.dart';

final List<ClassSession> mockSessions = [
  ClassSession(
    id: '1',
    subjectId: '1',
    subjectName: 'Signals & Systems',
    dayOfWeek: DayOfWeek.monday,
    startTime: const TimeOfDayModel(hour: 9, minute: 0),
    endTime: const TimeOfDayModel(hour: 10, minute: 0),
  ),

  ClassSession(
    id: '2',
    subjectId: '2',
    subjectName: 'Digital Electronics',
    dayOfWeek: DayOfWeek.tuesday,
    startTime: const TimeOfDayModel(hour: 11, minute: 0),
    endTime: const TimeOfDayModel(hour: 12, minute: 0),
  ),

  ClassSession(
    id: '3',
    subjectId: '3',
    subjectName: 'Some random subjects',
    dayOfWeek: DayOfWeek.monday,
    startTime: const TimeOfDayModel(hour: 11, minute: 0),
    endTime: const TimeOfDayModel(hour: 12, minute: 0),
  ),
];
