import 'package:frontend/features/subjects/domain/entities/subject_type.dart';

class Subject {
  final String id;
  final String name;
  final String code;
  final int semester;
  final int credits;
  final String? facultyName;
  final String? classroom;
  final int colorValue;
  final SubjectType type;
  final bool archived;
  final DateTime createdAt;

  const Subject({
    required this.id,
    required this.name,
    required this.code,
    required this.semester,
    required this.credits,
    required this.colorValue,
    required this.type,
    required this.archived,
    required this.createdAt,
    this.facultyName,
    this.classroom,
  });
}
