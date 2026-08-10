import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_page_scaffold.dart';
import 'package:frontend/features/assignments/data/repositories/mock_assignment_repository.dart';
import 'package:frontend/features/assignments/domain/entities/assignment.dart';
import 'package:frontend/features/assignments/domain/enums/assignment_status.dart';
import 'package:frontend/features/assignments/domain/enums/effort_required.dart';

class AssignmentDetailsPage extends StatefulWidget {
  final Assignment assignment;
  const AssignmentDetailsPage({super.key, required this.assignment});

  @override
  State<AssignmentDetailsPage> createState() => _AssignmentDetailsPageState();
}

class _AssignmentDetailsPageState extends State<AssignmentDetailsPage> {
  final MockAssignmentRepository repository = MockAssignmentRepository();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime selectedDueDate;
  late AssignmentStatus selectedStatus;
  late EffortRequired selectedEffort;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.assignment.title);
    descriptionController = TextEditingController(
      text: widget.assignment.description,
    );
    selectedDueDate = widget.assignment.dueDate;
    selectedStatus = widget.assignment.status;
    selectedEffort = widget.assignment.effortRequired;
  }

  Future<void> _selectDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2026),
      lastDate: DateTime(2100),
      initialDate: selectedDueDate,
    );
    if (pickedDate != null) {
      setState(() {
        selectedDueDate = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: "Assignment Details",
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Due Date'),
            subtitle: Text(
              '${selectedDueDate.day}/'
              '${selectedDueDate.month}/'
              '${selectedDueDate.year}',
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
          const SizedBox(height: 16),
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
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _saveChanges,
            icon: const Icon(Icons.save),
            label: const Text('Save Changes'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _deleteAssignment,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete Assignment'),
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

  Future<void> _saveChanges() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Title cannot be empty')));
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Description cannot be empty.")),
      );
      return;
    }
    final updatedAssignment = Assignment(
      id: widget.assignment.id,
      subjectId: widget.assignment.subjectId,
      description: descriptionController.text.trim(),
      dueDate: selectedDueDate,
      effortRequired: selectedEffort,
      title: titleController.text.trim(),
      solutionDocuments: widget.assignment.solutionDocuments,
      status: selectedStatus,
      supportingDocuments: widget.assignment.supportingDocuments,
    );
    await repository.updateAssignment(updatedAssignment);
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _deleteAssignment() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Assignment'),
          content: const Text('This Assignment will be permanently removed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }
    await repository.deleteAssignment(widget.assignment.id);
    if (!mounted) return;
    Navigator.pop(context);
  }
}
