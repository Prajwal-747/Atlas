import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_scaffold.dart';
import 'package:frontend/features/subjects/domain/entities/subject.dart';
import 'package:frontend/features/subjects/data/repositories/mock_subject_repository.dart';
import 'package:frontend/features/subjects/presentation/widgets/subject_list.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  final _repository = MockSubjectRepository();

  List<Subject> _subjects = [];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    _subjects = await _repository.getAllSubjects();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(child: SubjectList(subjects: _subjects));
  }
}
