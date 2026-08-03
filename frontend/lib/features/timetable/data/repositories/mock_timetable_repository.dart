import 'package:frontend/features/timetable/data/datasources/mock_timetable_data.dart';
import 'package:frontend/features/timetable/domain/entities/class_session.dart';
import 'package:frontend/features/timetable/domain/entities/day_of_week.dart';
import 'package:frontend/features/timetable/domain/repositories/timetable_repository.dart';

class MockTimetableRepository implements TimetableRepository {
  @override
  Future<List<ClassSession>> getAllSessions() async {
    return mockSessions;
  }

  @override
  Future<List<ClassSession>> getSessionsForDay(DayOfWeek day) async {
    return mockSessions.where((session) => session.dayOfWeek == day).toList();
  }

  @override
  Future<void> addSession(ClassSession session) async {
    mockSessions.add(session);
  }

  @override
  Future<void> updateSession(ClassSession session) async {
    final index = mockSessions.indexWhere(
      (existingSession) => existingSession.id == session.id,
    );
    if (index != -1) {
      mockSessions[index] = session;
    }
  }

  @override
  Future<void> deleteSession(String id) async {
    mockSessions.removeWhere((session) => session.id == id);
  }
}
