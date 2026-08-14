import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_page_scaffold.dart';
import 'package:frontend/core/widgets/section_title.dart';
import 'package:frontend/features/assignments/data/repositories/mock_assignment_repository.dart';
import 'package:frontend/features/assignments/domain/entities/assignment.dart';
import 'package:frontend/features/assignments/domain/enums/assignment_status.dart';
import 'package:frontend/features/assignments/presentation/pages/assignment_details_page.dart';
import 'package:frontend/features/assignments/presentation/widgets/assignment_card.dart';
import 'package:frontend/features/subjects/data/repositories/mock_subject_repository.dart';
import 'package:frontend/features/subjects/domain/entities/subject.dart';
import 'package:frontend/features/assignments/presentation/pages/add_assignment_page.dart';

class AssignmentPage extends StatefulWidget {
  final String subjectId;
  final String subjectName;

  const AssignmentPage({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<StatefulWidget> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  final MockAssignmentRepository assignmentRepository =
      MockAssignmentRepository();

  final MockSubjectRepository subjectRepository = MockSubjectRepository();
  late Future<List<Assignment>> assignments;
  late Future<Subject?> subject;

  Future<void> _reloadAssignments() async {
    setState(() {
      assignments = assignmentRepository.getAssignmentsForSubject(
        widget.subjectId,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    assignments = assignmentRepository.getAssignmentsForSubject(
      widget.subjectId,
    );
    subject = subjectRepository.getSubjectById(widget.subjectId);
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: "${widget.subjectName} Assignments",
      onFabPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddAssignmentPage(
              subjectId: widget.subjectId,
              subjectName: widget.subjectName,
            ),
          ),
        );
        await _reloadAssignments();
      },
      child: FutureBuilder<List<Assignment>>(
        future: assignments,
        builder: (context, assignmentSnapshot) {
          if (assignmentSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (assignmentSnapshot.hasError) {
            return Center(child: Text(assignmentSnapshot.error.toString()));
          }
          if (!assignmentSnapshot.hasData || assignmentSnapshot.data!.isEmpty) {
            return const Center(child: Text("No assignments found."));
          }
          final assignmentList = assignmentSnapshot.data!;
          final activeAssignments = assignmentList.where((assignment) {
            return assignment.status != AssignmentStatus.submitted ||
                assignment.status != AssignmentStatus.graded;
          }).toList()..sort((a, b) => a.dueDate.compareTo((b.dueDate)));
          final completedAssignments = assignmentList.where((assignment) {
            return assignment.status == AssignmentStatus.submitted ||
                assignment.status == AssignmentStatus.graded;
          }).toList()..sort((a, b) => b.dueDate.compareTo(a.dueDate));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (activeAssignments.isNotEmpty) ...[
                const SectionTitle(title: "Due Soon"),
                const SizedBox(height: 12),

                ...activeAssignments.map(
                  (assignment) => AssignmentCard(
                    assignment: assignment,
                    showSubject: false,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AssignmentDetailsPage(assignment: assignment),
                        ),
                      );
                      await _reloadAssignments();
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
              if (completedAssignments.isNotEmpty) ...[
                const SectionTitle(title: "Completed"),
                const SizedBox(height: 12),

                ...completedAssignments.map(
                  (assignment) => AssignmentCard(
                    assignment: assignment,
                    showSubject: false,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AssignmentDetailsPage(assignment: assignment),
                        ),
                      );
                      await _reloadAssignments();
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
