import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_page_scaffold.dart';
import 'package:frontend/core/widgets/section_title.dart';
import 'package:frontend/features/assignments/data/repositories/mock_assignment_repository.dart';
import 'package:frontend/features/assignments/domain/entities/assignment.dart';
import 'package:frontend/features/assignments/domain/enums/assignment_status.dart';
import 'package:frontend/features/assignments/presentation/widgets/assignment_card.dart';
import 'package:frontend/features/assignments/presentation/pages/assignment_details_page.dart';

class AssignmentOverviewPage extends StatefulWidget {
  const AssignmentOverviewPage({super.key});

  @override
  State<AssignmentOverviewPage> createState() => _AssignmentOverviewPageState();
}

class _AssignmentOverviewPageState extends State<AssignmentOverviewPage> {
  final MockAssignmentRepository assignmentRepository =
      MockAssignmentRepository();

  late Future<List<Assignment>> assignments;

  @override
  void initState() {
    super.initState();
    assignments = assignmentRepository.getAllAssignments();
  }

  Future<void> _reloadAssignments() async {
    setState(() {
      assignments = assignmentRepository.getAllAssignments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Assignments',
      child: FutureBuilder<List<Assignment>>(
        future: assignments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No assignments found.'));
          }
          final assignmentList = snapshot.data!;
          final activeAssignments =
              assignmentList
                  .where(
                    (assignment) =>
                        assignment.status != AssignmentStatus.submitted &&
                        assignment.status != AssignmentStatus.graded,
                  )
                  .toList()
                ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
          final completedAssignments =
              assignmentList
                  .where(
                    (assignment) =>
                        assignment.status == AssignmentStatus.submitted &&
                        assignment.status == AssignmentStatus.graded,
                  )
                  .toList()
                ..sort((a, b) => b.dueDate.compareTo(a.dueDate));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (activeAssignments.isNotEmpty) ...[
                const SectionTitle(title: 'Due Soon'),
                const SizedBox(height: 12),
                ...activeAssignments.map(
                  (assignment) => AssignmentCard(
                    assignment: assignment,
                    showSubject: true,
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
                const SizedBox(height: 12),
              ],
              if (completedAssignments.isNotEmpty) ...[
                const SectionTitle(title: 'Completed'),
                const SizedBox(height: 12),
                ...completedAssignments.map(
                  (assignment) => AssignmentCard(
                    assignment: assignment,
                    showSubject: true,
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
              if (activeAssignments.isEmpty && completedAssignments.isEmpty)
                const Center(child: Text('No assignments found.')),
            ],
          );
        },
      ),
    );
  }
}
