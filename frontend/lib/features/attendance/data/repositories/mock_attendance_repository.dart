import 'package:frontend/features/attendance/data/datasources/mock_attendance_data.dart';
import 'package:frontend/features/attendance/domain/entities/attendance_record.dart';
import 'package:frontend/features/attendance/domain/enums/attendance_status.dart';
import 'package:frontend/features/attendance/domain/repositories/attendance_repository.dart';

class MockAttendanceRepository implements AttendanceRepository {
  @override
  Future<List<AttendanceRecord>> getAttendanceForSubject(
    String subjectId,
  ) async {
    return mockAttendanceRecords
        .where((record) => record.subjectId == subjectId)
        .toList();
  }

  @override
  Future<void> addAttendanceRecord(AttendanceRecord record) async {
    mockAttendanceRecords.add(record);
  }

  @override
  Future<void> updateAttendanceRecord(AttendanceRecord record) async {
    final index = mockAttendanceRecords.indexWhere(
      (existingRecord) => existingRecord.id == record.id,
    );
    if (index != -1) {
      mockAttendanceRecords[index] = record;
    }
  }

  @override
  Future<void> deleteAttendanceRecord(String id) async {
    mockAttendanceRecords.removeWhere((record) => record.id == id);
  }

  Future<void> markAttendance({
    required String subjectId,
    required AttendanceStatus status,
  }) async {
    final now = DateTime.now();
    final existingIndex = mockAttendanceRecords.indexWhere(
      (record) =>
          record.subjectId == subjectId &&
          record.date.year == now.year &&
          record.date.month == now.month &&
          record.date.day == now.day,
    );
    if (existingIndex != -1) {
      final existing = mockAttendanceRecords[existingIndex];

      mockAttendanceRecords[existingIndex] = AttendanceRecord(
        id: existing.id,
        subjectId: existing.subjectId,
        date: existing.date,
        status: status,
      );
    } else {
      mockAttendanceRecords.add(
        AttendanceRecord(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          subjectId: subjectId,
          date: DateTime.now(),
          status: status,
        ),
      );
    }
  }
}
