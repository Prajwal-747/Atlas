import '../entities/class_session.dart';
import '../entities/day_of_week.dart';

abstract class TimetableRepository {
  Future<List<ClassSession>> getAllSessions();
  Future<List<ClassSession>> getSessionsForDay(DayOfWeek day);
  Future<void> addSession(ClassSession session);
  Future<void> updateSession(ClassSession session);
  Future<void> deleteSession(String id);
}
