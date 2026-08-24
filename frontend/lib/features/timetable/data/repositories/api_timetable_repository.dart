import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/features/timetable/domain/entities/class_session.dart';
import 'package:frontend/features/timetable/domain/entities/day_of_week.dart';
import 'package:frontend/features/timetable/domain/entities/time_of_day_model.dart';
import 'package:frontend/features/timetable/domain/repositories/timetable_repository.dart';

class ApiTimetableRepository implements TimetableRepository {
  final ApiClient apiClient;
  ApiTimetableRepository({ApiClient? apiClient})
    : apiClient = apiClient ?? ApiClient();

  ClassSession _fromJson(Map<String, dynamic> json) {
    return ClassSession(
      id: json['id'].toString(),
      subjectId: json['subject'].toString(),
      subjectName: json['subject_name'] as String,
      dayOfWeek: _dayFromString(json['day_of_week'] as String),
      startTime: _timeFromString(json['start_time'] as String),
      endTime: _timeFromString(json['end_time'] as String),
    );
  }

  DayOfWeek _dayFromString(String value) {
    switch (value) {
      case 'monday':
        return DayOfWeek.monday;
      case 'tuesday':
        return DayOfWeek.tuesday;
      case 'wednesday':
        return DayOfWeek.wednesday;
      case 'thursday':
        return DayOfWeek.thursday;
      case 'friday':
        return DayOfWeek.friday;
      case 'saturday':
        return DayOfWeek.saturday;
      case 'sunday':
        return DayOfWeek.sunday;
      default:
        throw Exception('Unknown day: $value');
    }
  }

  String _dayToString(DayOfWeek day) {
    switch (day) {
      case DayOfWeek.monday:
        return 'monday';
      case DayOfWeek.tuesday:
        return 'tuesday';
      case DayOfWeek.wednesday:
        return 'wednesday';
      case DayOfWeek.thursday:
        return 'thursday';
      case DayOfWeek.friday:
        return 'friday';
      case DayOfWeek.saturday:
        return 'saturday';
      case DayOfWeek.sunday:
        return 'sunday';
    }
  }

  TimeOfDayModel _timeFromString(String value) {
    final parts = value.split(':');
    return TimeOfDayModel(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _timeToString(TimeOfDayModel time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute:00';
  }

  Map<String, dynamic> _toJson(ClassSession session) {
    return {
      'subject': int.parse(session.subjectId),
      'day_of_week': _dayToString(session.dayOfWeek),
      'start_time': _timeToString(session.startTime),
      'end_time': _timeToString(session.endTime),
    };
  }

  @override
  Future<List<ClassSession>> getAllSessions() async {
    final response = await apiClient.dio.get('/timetable/');
    final data = response.data as List;
    return data.map((json) => _fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<ClassSession>> getSessionsForDay(DayOfWeek day) async {
    final sessions = await getAllSessions();
    return sessions.where((session) => session.dayOfWeek == day).toList();
  }

  @override
  Future<void> addSession(ClassSession session) async {
    await apiClient.dio.post('/timetable/', data: _toJson(session));
  }

  @override
  Future<void> updateSession(ClassSession session) async {
    await apiClient.dio.patch(
      '/timetable/${session.id}/',
      data: _toJson(session),
    );
  }

  @override
  Future<void> deleteSession(String id) async {
    await apiClient.dio.delete('/timetable/$id/');
  }
}
