import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_page_scaffold.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/features/assignments/domain/enums/assignment_status.dart';
import 'package:frontend/features/assignments/domain/enums/effort_required.dart';
import 'package:frontend/features/assignments/data/repositories/mock_assignment_repository.dart';
import 'package:frontend/features/assignments/domain/entities/assignment.dart';

class AddAssignmentPage extends StatefulWidget {
  final String subjectId;
  final String subjectName;

  const AddAssignmentPage({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<AddAssignmentPage> createState() => _AddAssignmentPageState();
}

class _AddAssignmentPageState extends State<AddAssignmentPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final MockAssignmentRepository repository = MockAssignmentRepository();

  DateTime? selectedDueDate;

  AssignmentStatus selectedStatus = AssignmentStatus.notStarted;
  EffortRequired selectedEffort = EffortRequired.medium;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final PickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2026),
      lastDate: DateTime(2100),
    );

    if (PickedDate != null) {
      setState(() {
        selectedDueDate = PickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Add Assignment',
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            widget.subjectName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Due Date'),
            subtitle: Text(
              selectedDueDate == null
                  ? 'Select a due date'
                  : '${selectedDueDate!.day}/'
                        '${selectedDueDate!.month}/'
                        '${selectedDueDate!.year}',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: _selectDueDate,
          ),
          const Divider(),
          DropdownButtonFormField<AssignmentStatus>(
            initialValue: selectedStatus,
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
            items: AssignmentStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(_statusText(status)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedStatus = value;
                });
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<EffortRequired>(
            initialValue: selectedEffort,
            decoration: const InputDecoration(
              labelText: 'Effort Required',
              border: OutlineInputBorder(),
            ),
            items: EffortRequired.values.map((effort) {
              return DropdownMenuItem(
                value: effort,
                child: Text(_effortText(effort)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedEffort = value;
                });
              }
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: _saveAssignment,
            label: const Text('Save Assignment'),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }

  String _statusText(AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.notStarted:
        return 'Not Started';
      case AssignmentStatus.inProgress:
        return 'In Progress';
      case AssignmentStatus.submitted:
        return 'Submitted';
      case AssignmentStatus.graded:
        return 'Graded';
    }
  }

  String _effortText(EffortRequired effort) {
    switch (effort) {
      case EffortRequired.veryLow:
        return 'Very Low';
      case EffortRequired.low:
        return 'Low';
      case EffortRequired.medium:
        return 'Medium';
      case EffortRequired.high:
        return 'High';
      case EffortRequired.veryHigh:
        return 'Very High';
    }
  }

  Future<void> _saveAssignment() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an assignment title.")),
      );
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a description.")),
      );
      return;
    }
    if (selectedDueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a due date.")),
      );
      return;
    }
    final assignment = Assignment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      subjectId: widget.subjectId,
      description: descriptionController.text.trim(),
      dueDate: selectedDueDate!,
      effortRequired: selectedEffort,
      title: titleController.text.trim(),
      solutionDocuments: [],
      status: selectedStatus,
      supportingDocuments: [],
    );
    await repository.addAssignment(assignment);
    if (!mounted) return;

    Navigator.pop(context);
  }
}
