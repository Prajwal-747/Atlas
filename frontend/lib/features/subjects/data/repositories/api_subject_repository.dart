import 'package:flutter/material.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/features/subjects/domain/entities/subject.dart';
import 'package:frontend/features/subjects/domain/entities/subject_type.dart';
import 'package:frontend/features/subjects/domain/repositories/subject_repository.dart';

class ApiSubjectRepository implements SubjectRepository {
  final ApiClient apiClient;
  ApiSubjectRepository({ApiClient? apiClient})
    : apiClient = apiClient ?? ApiClient();

  Subject _fromJson(Map<String, dynamic> json) {
    final colorValue = json['color_value'] as int;

    return Subject(
      id: json['id'].toString(),
      name: json['name'] as String,
      code: json['code'] as String,
      semester: json['semester'] as int,
      credits: json['credits'] as int,
      colorValue: colorValue,
      color: Color(colorValue),
      type: _subjectTypeFromString(json['type'] as String),
      archived: json['archived'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  SubjectType _subjectTypeFromString(String value) {
    switch (value) {
      case 'theory':
        return SubjectType.theory;
      case 'lab':
        return SubjectType.lab;
      case 'theory_and_lab':
        return SubjectType.theoryAndLab;
      default:
        throw Exception('Unknown subject type: $value');
    }
  }

  Map<String, dynamic> _toJson(Subject subject) {
    return {
      'name': subject.name,
      'code': subject.code,
      'semester': subject.semester,
      'credits': subject.credits,
      'faculty_name': subject.facultyName,
      'classroom': subject.classroom,
      'color_value': subject.colorValue,
      'type': _subjectTypeToString(subject.type),
      'archived': subject.archived,
    };
  }

  String _subjectTypeToString(SubjectType type) {
    switch (type) {
      case SubjectType.theory:
        return 'theory';
      case SubjectType.lab:
        return 'lab';
      case SubjectType.theoryAndLab:
        return 'theory_and_lab';
    }
  }

  @override
  Future<List<Subject>> getAllSubjects() async {
    final response = await apiClient.dio.get('/subjects/');
    final data = response.data as List;
    return data.map((json) => _fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<Subject?> getSubjectById(String id) async {
    try {
      final response = await apiClient.dio.get('/subjects/$id/');
      return _fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addSubject(Subject subject) async {
    await apiClient.dio.post('/subjects/', data: _toJson(subject));
  }

  @override
  Future<void> updateSubject(Subject subject) async {
    await apiClient.dio.patch(
      '/subjects/${subject.id}/',
      data: _toJson(subject),
    );
  }

  @override
  Future<void> deleteSubject(String id) async {
    await apiClient.dio.delete('/subjects/$id/');
  }
}
