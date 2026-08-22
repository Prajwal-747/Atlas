import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/widgets/app_page_scaffold.dart';
import 'package:frontend/features/subjects/data/repositories/api_subject_repository.dart';
import 'package:frontend/features/subjects/domain/entities/subject.dart';
import 'package:frontend/features/subjects/domain/entities/subject_type.dart';

class AddSubjectPage extends StatefulWidget {
  const AddSubjectPage({super.key});

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final ApiSubjectRepository subjectRepository = ApiSubjectRepository();
  final nameController = TextEditingController();
  final codeController = TextEditingController();
  final semesterController = TextEditingController(text: '1');
  final creditsController = TextEditingController(text: '3');
  final facultyController = TextEditingController();
  final classroomController = TextEditingController();

  SubjectType selectedType = SubjectType.theory;
  bool isSaving = false;

  @override
  void dispose() {
    nameController.dispose();
    codeController.dispose();
    semesterController.dispose();
    creditsController.dispose();
    facultyController.dispose();
    classroomController.dispose();
    super.dispose();
  }

  Future<void> _saveSubject() async {
    final name = nameController.text.trim();
    final code = codeController.text.trim();
    final semester = int.tryParse(semesterController.text.trim());
    final credits = int.tryParse(creditsController.text.trim());

    if (name.isEmpty || code.isEmpty || semester == null || credits == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all required fields.')),
      );
      return;
    }
    setState(() {
      isSaving = true;
    });

    final subject = Subject(
      id: '',
      name: name,
      color: const Color(0xFF6750A4),
      code: code,
      semester: semester,
      credits: credits,
      colorValue: 0xFF6750A4,
      type: selectedType,
      archived: false,
      createdAt: DateTime.now(),
      facultyName: facultyController.text.trim().isEmpty
          ? null
          : facultyController.text.trim(),
      classroom: classroomController.text.trim().isEmpty
          ? null
          : classroomController.text.trim(),
    );

    try {
      await subjectRepository.addSubject(subject);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save subject: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  String _typeText(SubjectType type) {
    switch (type) {
      case SubjectType.theory:
        return 'Theory';
      case SubjectType.lab:
        return 'Lab';
      case SubjectType.theoryAndLab:
        return 'Theory + Lab';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Add Subject',
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Subject Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: codeController,
            decoration: const InputDecoration(
              labelText: 'Subject Code',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: semesterController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Semester',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: creditsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Credits',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: facultyController,
            decoration: const InputDecoration(
              labelText: 'Faculty Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: classroomController,
            decoration: const InputDecoration(
              labelText: 'Classroom',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<SubjectType>(
            initialValue: selectedType,
            decoration: const InputDecoration(
              labelText: 'Type',
              border: OutlineInputBorder(),
            ),
            items: SubjectType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(_typeText(type)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedType = value;
                });
              }
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: isSaving ? null : _saveSubject,
            icon: isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(),
                  )
                : const Icon(Icons.save),
            label: Text(isSaving ? 'Saving...' : 'Save Subject'),
          ),
        ],
      ),
    );
  }
}
