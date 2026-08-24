import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_page_scaffold.dart';
import 'package:frontend/features/subjects/domain/entities/subject.dart';
import 'package:frontend/features/subjects/domain/entities/subject_type.dart';
import 'package:frontend/features/subjects/data/repositories/api_subject_repository.dart';
import 'package:frontend/features/subjects/presentation/widgets/subject_form.dart';

class EditSubjectPage extends StatefulWidget {
  final Subject subject;
  const EditSubjectPage({super.key, required this.subject});
  @override
  State<EditSubjectPage> createState() => _EditSubjectPageState();
}

class _EditSubjectPageState extends State<EditSubjectPage> {
  final ApiSubjectRepository subjectRepository = ApiSubjectRepository();
  bool isSaving = false;
  Future<void> _updateSubject({
    required String name,
    required String code,
    required int semester,
    required int credits,
    String? facultyName,
    String? classroom,
    required SubjectType type,
  }) async {
    setState(() {
      isSaving = true;
    });
    final updatedSubject = Subject(
      id: widget.subject.id,
      name: name,
      color: Color(widget.subject.colorValue),
      code: code,
      semester: semester,
      credits: credits,
      colorValue: widget.subject.colorValue,
      type: type,
      archived: widget.subject.archived,
      createdAt: widget.subject.createdAt,
      facultyName: facultyName,
      classroom: classroom,
    );
    try {
      await subjectRepository.updateSubject(updatedSubject);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update Subject: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final subject = widget.subject;
    return AppPageScaffold(
      title: 'Edit Subject',
      child: SubjectForm(
        initialName: subject.name,
        initialCode: subject.code,
        initialSemester: subject.semester,
        initialCredits: subject.credits,
        initialFacultyName: subject.facultyName,
        initialClassroom: subject.classroom,
        initialType: subject.type,
        buttonText: 'Save Changes',
        isSaving: isSaving,
        onSubmit: _updateSubject,
      ),
    );
  }
}
