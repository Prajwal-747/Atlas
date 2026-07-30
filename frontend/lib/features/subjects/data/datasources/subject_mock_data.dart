import 'package:frontend/features/subjects/domain/entities/subject.dart';
import 'package:frontend/features/subjects/domain/entities/subject_type.dart';

final mockSubjects = [
  Subject(
    id: "1",
    name: 'Signals and Systems',
    code: 'EC301',
    semester: 3,
    credits: 4,
    type: SubjectType.theory,
    facultyName: 'Dr. Sharma',
    classroom: 'AB-402',
    colorValue: 0xFF1976D2,
    archived: false,
    createdAt: DateTime.now(),
  ),
  Subject(
    id: '2',
    name: 'Digital Electronics',
    code: 'EC302',
    semester: 3,
    credits: 4,
    type: SubjectType.theory,
    facultyName: 'Dr. Rao',
    classroom: 'AB-301',
    colorValue: 0xFF388E3C,
    archived: false,
    createdAt: DateTime.now(),
  ),
];
