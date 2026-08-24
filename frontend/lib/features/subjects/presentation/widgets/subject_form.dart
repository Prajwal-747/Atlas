import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/features/subjects/domain/entities/subject_type.dart';

class SubjectForm extends StatefulWidget {
  final SubjectType initialType;
  final String initialName;
  final String initialCode;
  final int initialSemester;
  final int initialCredits;
  final String? initialFacultyName;
  final String? initialClassroom;
  final String buttonText;
  final bool isSaving;
  final Future<void> Function({
    required String name,
    required String code,
    required int semester,
    required int credits,
    String? facultyName,
    String? classroom,
    required SubjectType type,
  })
  onSubmit;
  const SubjectForm({
    this.initialType = SubjectType.theory,
    this.initialName = '',
    this.initialCode = '',
    this.initialSemester = 1,
    this.initialCredits = 3,
    this.initialFacultyName,
    this.initialClassroom,
    required this.buttonText,
    required this.isSaving,
    required this.onSubmit,
    super.key,
  });

  @override
  State<SubjectForm> createState() => _SubjectFormState();
}

class _SubjectFormState extends State<SubjectForm> {
  late final TextEditingController nameController;
  late final TextEditingController codeController;
  late final TextEditingController semesterController;
  late final TextEditingController creditsController;
  late final TextEditingController facultyController;
  late final TextEditingController classroomController;

  late SubjectType selectedType;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
    codeController = TextEditingController(text: widget.initialCode);
    semesterController = TextEditingController(
      text: widget.initialSemester.toString(),
    );
    creditsController = TextEditingController(
      text: widget.initialCredits.toString(),
    );
    facultyController = TextEditingController(
      text: widget.initialFacultyName ?? '',
    );
    classroomController = TextEditingController(
      text: widget.initialClassroom ?? '',
    );
    selectedType = widget.initialType;
  }

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

  Future<void> _submit() async {
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
    await widget.onSubmit(
      name: name,
      code: code,
      semester: semester,
      credits: credits,
      facultyName: facultyController.text.trim().isEmpty
          ? null
          : facultyController.text.trim(),
      classroom: classroomController.text.trim().isEmpty
          ? null
          : classroomController.text.trim(),
      type: selectedType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
            return DropdownMenuItem(value: type, child: Text(_typeText(type)));
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
          onPressed: widget.isSaving ? null : _submit,
          icon: widget.isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(),
                )
              : const Icon(Icons.save),
          label: Text(widget.isSaving ? 'Saving...' : widget.buttonText),
        ),
      ],
    );
  }
}
