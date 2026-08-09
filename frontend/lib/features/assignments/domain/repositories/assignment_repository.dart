import '../entities/assignment.dart';

abstract class AssignmentRepository {
  Future<List<Assignment>> getAssignmentsForSubject(String subjectId);
  Future<void> addAssignment(Assignment assignment);
  Future<void> updateAssignment(Assignment assignment);
  Future<void> deleteAssignment(String id);
}
