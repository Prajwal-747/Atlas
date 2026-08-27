import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/features/attendance/domain/entities/attendance_record.dart';
import 'package:frontend/features/attendance/domain/enums/attendance_status.dart';
import 'package:frontend/features/attendance/domain/repositories/attendance_repository.dart';

class ApiAttendanceRepository implements AttendanceRepository {
  final ApiClient apiClient;
  ApiAttendanceRepository({ApiClient? apiClient})
    : apiClient = apiClient ?? ApiClient();
  AttendanceStatus _statusFromString(String value) {
    switch (value) {
      case 'present':
        return AttendanceStatus.present;
      case 'absent':
        return AttendanceStatus.absent;
      case 'late':
        return AttendanceStatus.late;
      default:
        throw Exception('Unknown attendance status: $value');
    }
  }

  String _statusToString(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return 'present';
      case AttendanceStatus.absent:
        return 'absent';
      case AttendanceStatus.late:
        return 'late';
    }
  }

  AttendanceRecord _fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'].toString(),
      subjectId: json['subject'].toString(),
      date: DateTime.parse(json['date'] as String),
      status: _statusFromString(json['status'] as String),
    );
  }

  Map<String, dynamic> _toJson(AttendanceRecord record) {
    return {
      'subject': int.parse(record.subjectId),
      'date': record.date.toIso8601String().split('T').first,
      'status': _statusToString(record.status),
    };
  }

  @override
  Future<List<AttendanceRecord>> getAttendanceForSubject(
    String subjectId,
  ) async {
    final response = await apiClient.dio.get('/attendance/');
    final data = response.data as List;
    return data
        .map((json) => _fromJson(json as Map<String, dynamic>))
        .where((record) => record.subjectId == subjectId)
        .toList();
  }

  @override
  Future<List<AttendanceRecord>> getAllAttendance() async {
    final response = await apiClient.dio.get('/attendance/');
    final data = response.data as List;
    return data.map((json) => _fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> addAttendanceRecord(AttendanceRecord record) async {
    try {
      await apiClient.dio.post('/attendance/', data: _toJson(record));
    } on DioException catch (e) {
      debugPrint('ATTENDANCE RETHROW ERROR: ${e.response?.data}');
      rethrow;
    }
  }

  @override
  Future<void> updateAttendanceRecord(AttendanceRecord record) async {
    await apiClient.dio.patch(
      '/attendance/${record.id}/',
      data: _toJson(record),
    );
  }

  @override
  Future<void> deleteAttendanceRecord(String id) async {
    await apiClient.dio.delete('/attendance/$id/');
  }

  Future<void> markAttendance({
    required String subjectId,
    required AttendanceStatus status,
  }) async {
    final now = DateTime.now();
    final records = await getAttendanceForSubject(subjectId);
    AttendanceRecord? existing;
    for (final record in records) {
      if (record.date.year == now.year &&
          record.date.month == now.month &&
          record.date.day == now.day) {
        existing = record;
        break;
      }
    }
    if (existing != null) {
      await updateAttendanceRecord(
        AttendanceRecord(
          id: existing.id,
          subjectId: existing.subjectId,
          date: existing.date,
          status: status,
        ),
      );
    } else {
      await addAttendanceRecord(
        AttendanceRecord(
          id: '',
          subjectId: subjectId,
          date: now,
          status: status,
        ),
      );
    }
  }
}
