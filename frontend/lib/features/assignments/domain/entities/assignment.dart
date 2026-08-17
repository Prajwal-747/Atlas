import '../enums/assignment_status.dart';
import '../enums/effort_required.dart';

class Assignment {
  final String id;
  final String subjectId;
  final String title;
  final String description;
  final DateTime dueDate;
  final AssignmentStatus status;
  final EffortRequired effortRequired;
  final List<String> supportingDocuments;
  final List<String> solutionDocuments;

  const Assignment({
    required this.id,
    required this.subjectId,
    required this.description,
    required this.dueDate,
    required this.effortRequired,
    required this.title,
    required this.solutionDocuments,
    required this.status,
    required this.supportingDocuments,
  });
}
