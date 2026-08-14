import 'package:frontend/features/assignments/data/datasources/mock_assignment_data.dart';
import 'package:frontend/features/assignments/domain/entities/assignment.dart';
import 'package:frontend/features/assignments/domain/repositories/assignment_repository.dart';

class MockAssignmentRepository implements AssignmentRepository {
  @override
  Future<List<Assignment>> getAssignmentsForSubject(String subjectId) async {
    return mockAssignments
        .where((assignment) => assignment.subjectId == subjectId)
        .toList();
  }
  Future<List<Assignment>> getAllAssignments() async {
    return mockAssignments.toList();
  }

  @override
  Future<void> addAssignment(Assignment assignment) async {
    mockAssignments.add(assignment);
  }

  @override
  Future<void> updateAssignment(Assignment assignment) async {
    final index = mockAssignments.indexWhere(
      (existing) => existing.id == assignment.id,
    );
    if (index != -1) {
      mockAssignments[index] = assignment;
    }
  }

  @override
  Future<void> deleteAssignment(String id) async {
    mockAssignments.removeWhere((assignment) => assignment.id == id);
  }
}
