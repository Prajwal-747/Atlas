import '../enums/attendance_status.dart';

class AttendanceRecord {
  final String id;
  final String subjectId;
  final DateTime date;
  final AttendanceStatus status;

  const AttendanceRecord({
    required this.id,
    required this.subjectId,
    required this.date,
    required this.status,
  });
}
