import 'package:frontend/features/subjects/domain/entities/subject.dart';
import 'package:frontend/features/subjects/domain/repositories/subject_repository.dart';
import 'package:frontend/features/subjects/data/datasources/subject_mock_data.dart';

class MockSubjectRepository implements SubjectRepository {
  @override
  Future<List<Subject>> getAllSubjects() async => mockSubjects;

  @override
  Future<Subject?> getSubjectById(String id) async {
    try {
      return mockSubjects.firstWhere((subject) => subject.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addSubject(Subject subject) async {}

  @override
  Future<void> updateSubject(Subject subject) async {}

  @override
  Future<void> deleteSubject(String id) async {}
}
