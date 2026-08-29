import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/features/assignments/domain/entities/assignment.dart';
import 'package:frontend/features/assignments/domain/enums/assignment_status.dart';
import 'package:frontend/features/assignments/domain/enums/effort_required.dart';
import 'package:frontend/features/assignments/domain/repositories/assignment_repository.dart';

class ApiAssignmentRepository implements AssignmentRepository {
  final ApiClient apiClient;
  ApiAssignmentRepository({ApiClient? apiClient})
    : apiClient = apiClient ?? ApiClient();
  Assignment _fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'].toString(),
      subjectId: json['subject'].toString(),
      description: json['description'] as String,
      dueDate: DateTime.parse(json['due_date'] as String),
      effortRequired: _effortFromString(json['effort_required'] as String),
      title: json['title'] as String,
      solutionDocuments: List<String>.from(json['solution_documents'] ?? []),
      status: _statusFromString(json['status'] as String),
      supportingDocuments: List<String>.from(
        json['supporting_documents'] ?? [],
      ),
    );
  }

  AssignmentStatus _statusFromString(String value) {
    switch (value) {
      case 'not_started':
        return AssignmentStatus.notStarted;
      case 'in_progress':
        return AssignmentStatus.inProgress;
      case 'submitted':
        return AssignmentStatus.submitted;
      case 'graded':
        return AssignmentStatus.graded;
      default:
        throw Exception('Unknown assignment status: $value');
    }
  }

  String _statusToString(AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.notStarted:
        return 'not_started';
      case AssignmentStatus.inProgress:
        return 'in_progress';
      case AssignmentStatus.submitted:
        return 'submitted';
      case AssignmentStatus.graded:
        return 'graded';
    }
  }

  String _effortToString(EffortRequired effort) {
    switch (effort) {
      case EffortRequired.veryLow:
        return 'very_low';
      case EffortRequired.low:
        return 'low';
      case EffortRequired.medium:
        return 'medium';
      case EffortRequired.high:
        return 'high';
      case EffortRequired.veryHigh:
        return 'very_high';
    }
  }

  EffortRequired _effortFromString(String value) {
    switch (value) {
      case 'very_low':
        return EffortRequired.veryLow;
      case 'low':
        return EffortRequired.low;
      case 'medium':
        return EffortRequired.medium;
      case 'high':
        return EffortRequired.high;
      case 'very_high':
        return EffortRequired.veryHigh;
      default:
        throw Exception('Unknown effort required: $value');
    }
  }

  Map<String, dynamic> _toJson(Assignment assignment) {
    return {
      'subject': int.parse(assignment.subjectId),
      'title': assignment.title,
      'description': assignment.description,
      'due_date': assignment.dueDate.toIso8601String(),
      'status': _statusToString(assignment.status),
      'effort_required': _effortToString(assignment.effortRequired),
      'supporting_documents': assignment.supportingDocuments,
      'solution_documents': assignment.solutionDocuments,
    };
  }

  @override
  Future<List<Assignment>> getAssignmentsForSubject(String subjectId) async {
    final response = await apiClient.dio.get('/assignments/');
    final data = response.data as List;
    return data
        .map((json) => _fromJson(json as Map<String, dynamic>))
        .where((assignment) => assignment.subjectId == subjectId)
        .toList();
  }

  @override
  Future<List<Assignment>> getAllAssignments() async {
    final response = await apiClient.dio.get('/assignments/');
    final data = response.data as List;
    return data.map((json) => _fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> addAssignment(Assignment assignment) async {
    await apiClient.dio.post('/assignments/', data: _toJson(assignment));
  }

  @override
  Future<void> updateAssignment(Assignment assignment) async {
    await apiClient.dio.patch(
      '/assignments/${assignment.id}/',
      data: _toJson(assignment),
    );
  }

  @override
  Future<void> deleteAssignment(String id) async {
    await apiClient.dio.delete('/assignments/$id/');
  }

  Future<List<Assignment>> getDueSoonAssignments() async {
    final response = await apiClient.dio.get('/assignments/due-soon/');
    final data = response.data as List;

    return data.map((json) => _fromJson(json as Map<String, dynamic>)).toList();
  }
}
