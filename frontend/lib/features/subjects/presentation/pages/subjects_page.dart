import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_page_scaffold.dart';
import 'package:frontend/features/subjects/domain/entities/subject.dart';
import 'package:frontend/features/subjects/data/repositories/api_subject_repository.dart';
import 'package:frontend/features/subjects/presentation/widgets/subject_list.dart';
import 'package:frontend/features/subjects/presentation/pages/add_subject_page.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  final ApiSubjectRepository _repository = ApiSubjectRepository();

  List<Subject> _subjects = [];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    final subjects = await _repository.getAllSubjects();
    if (!mounted) return;
    setState(() {
      _subjects = subjects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Subjects',
      onFabPressed: () async {
        final created = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => const AddSubjectPage()),
        );
        if (created == true) {
          await _loadSubjects();
        }
      },
      child: SubjectList(subjects: _subjects, onChanged: _loadSubjects),
    );
  }
}
