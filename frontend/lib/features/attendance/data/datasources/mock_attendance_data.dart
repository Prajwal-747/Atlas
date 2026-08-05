import 'package:frontend/features/attendance/domain/entities/attendance_record.dart';
import 'package:frontend/features/attendance/domain/enums/attendance_status.dart';

final List<AttendanceRecord> mockAttendanceRecords = [
  AttendanceRecord(
    id: '1',
    subjectId: '1',
    date: DateTime(2026, 7, 28),
    status: AttendanceStatus.present,
  ),
  AttendanceRecord(
    id: '2',
    subjectId: '1',
    date: DateTime(2026, 7, 30),
    status: AttendanceStatus.present,
  ),
  AttendanceRecord(
    id: '3',
    subjectId: '1',
    date: DateTime(2026, 8, 1),
    status: AttendanceStatus.absent,
  ),
  AttendanceRecord(
    id: '4',
    subjectId: '1',
    date: DateTime(2026, 8, 3),
    status: AttendanceStatus.late,
  ),
  AttendanceRecord(
    id: '5',
    subjectId: '2',
    date: DateTime(2026, 7, 29),
    status: AttendanceStatus.present,
  ),
];
