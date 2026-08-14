import '../entities/attendance_record.dart';

abstract class AttendanceRepository {
  Future<List<AttendanceRecord>> getAttendanceForSubject(String subjectId);

  Future<List<AttendanceRecord>> getAllAttendance();

  Future<void> addAttendanceRecord(AttendanceRecord record);

  Future<void> updateAttendanceRecord(AttendanceRecord record);

  Future<void> deleteAttendanceRecord(String id);
}
