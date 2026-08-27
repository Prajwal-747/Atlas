import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_scaffold.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/features/assignments/presentation/pages/assignment_overview_page.dart';
import 'package:frontend/features/attendance/data/repositories/api_attendance_repository.dart';
import 'package:frontend/features/attendance/domain/entities/attendance_record.dart';
import 'package:frontend/features/attendance/domain/enums/attendance_status.dart';
import 'package:frontend/features/attendance/presentation/pages/attendance_overview_page.dart';
import 'package:frontend/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:frontend/features/dashboard/presentation/widgets/todays_classes_card.dart';
import 'package:frontend/features/dashboard/presentation/widgets/attendance_summary_card.dart';
import 'package:frontend/features/timetable/presentation/pages/timetable_page.dart';
import 'package:frontend/features/assignments/data/repositories/mock_assignment_repository.dart';
import 'package:frontend/features/dashboard/presentation/widgets/assignments_due_soon_card.dart';
import 'package:frontend/features/assignments/domain/entities/assignment.dart';
import 'package:frontend/features/assignments/presentation/pages/assignment_details_page.dart';
import 'package:frontend/features/timetable/data/repositories/mock_timetable_repository.dart';
import 'package:frontend/features/timetable/domain/entities/class_session.dart';
import 'package:frontend/features/timetable/domain/entities/day_of_week.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ApiAttendanceRepository attendanceRepository =
      ApiAttendanceRepository();
  late Future<List<AttendanceRecord>> attendanceRecords;
  final MockAssignmentRepository assignmentRepository =
      MockAssignmentRepository();
  late Future<List<Assignment>> assignments;
  final MockTimetableRepository timetableRepository = MockTimetableRepository();
  late Future<List<ClassSession>> todaysSessions;

  @override
  void initState() {
    super.initState();
    attendanceRecords = attendanceRepository.getAllAttendance();
    assignments = _loadAssignments();
    todaysSessions = _loadTodaysSessions();
  }

  Future<List<Assignment>> _loadAssignments() {
    return assignmentRepository.getAllAssignments();
  }

  Future<List<ClassSession>> _loadTodaysSessions() {
    final today = DateTime.now().weekday;
    final day = DayOfWeek.values[today - 1];
    return timetableRepository.getSessionsForDay(day);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: FutureBuilder(
        future: Future.wait([attendanceRecords, assignments, todaysSessions]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final attendance = snapshot.data![0] as List<AttendanceRecord>;
          final assignmentList = snapshot.data![1] as List<Assignment>;
          final sessionList = snapshot.data![2] as List<ClassSession>;
          final records = attendance;
          final presentCount = records
              .where((record) => record.status == AttendanceStatus.present)
              .length;
          final absentCount = records
              .where((record) => record.status == AttendanceStatus.absent)
              .length;
          final lateCount = records
              .where((record) => record.status == AttendanceStatus.late)
              .length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardHeader(),
              const SizedBox(height: AppSpacing.lg),
              AttendanceSummaryCard(
                presentCount: presentCount,
                absentCount: absentCount,
                lateCount: lateCount,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AttendanceOverviewPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              TodaysClassesCard(
                sessions: sessionList,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TimetablePage()),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              AssignmentsDueSoonCard(
                assignments: assignmentList,
                onAssignmentTap: (assignment) async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AssignmentDetailsPage(assignment: assignment),
                    ),
                  );
                  setState(() {
                    assignments = _loadAssignments();
                  });
                },
                onViewAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AssignmentOverviewPage(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
