import 'package:frontend/features/assignments/domain/entities/assignment.dart';
import 'package:frontend/features/assignments/domain/enums/assignment_status.dart';
import 'package:frontend/features/assignments/domain/enums/effort_required.dart';

final List<Assignment> mockAssignments = [
  Assignment(
    id: '1',
    subjectId: '1',
    title: 'Signals Lab Report',
    description: 'Complete the CRO experiment report.',
    dueDate: DateTime(2026, 8, 10),
    status: AssignmentStatus.inProgress,
    effortRequired: EffortRequired.high,
    supportingDocuments: [],
    solutionDocuments: [],
  ),
  Assignment(
    id: '2',
    subjectId: '1',
    title: 'Tutorial Sheet 3',
    description: 'Solve all tutorial problems.',
    dueDate: DateTime(2026, 8, 8),
    status: AssignmentStatus.notStarted,
    effortRequired: EffortRequired.medium,
    supportingDocuments: [],
    solutionDocuments: [],
  ),
  Assignment(
    id: '3',
    subjectId: '2',
    title: 'Digital Logic Assignment',
    description: 'Design combinational circuits.',
    dueDate: DateTime(2026, 8, 12),
    status: AssignmentStatus.submitted,
    effortRequired: EffortRequired.high,
    supportingDocuments: [],
    solutionDocuments: [],
  ),
];
