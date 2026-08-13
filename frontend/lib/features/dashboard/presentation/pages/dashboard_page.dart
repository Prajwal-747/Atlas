import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_scaffold.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/features/attendance/data/repositories/mock_attendance_repository.dart';
import 'package:frontend/features/attendance/domain/entities/attendance_record.dart';
import 'package:frontend/features/attendance/domain/enums/attendance_status.dart';
import 'package:frontend/features/attendance/presentation/pages/attendance_overview_page.dart';
import 'package:frontend/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:frontend/features/dashboard/presentation/widgets/todays_classes_card.dart';
import 'package:frontend/features/dashboard/presentation/widgets/attendance_summary_card.dart';
import 'package:frontend/features/timetable/presentation/pages/timetable_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final MockAttendanceRepository attendanceRepository =
      MockAttendanceRepository();
  late Future<List<AttendanceRecord>> attendanceRecords;

  @override
  void initState() {
    super.initState();
    attendanceRecords = attendanceRepository.getAllAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: FutureBuilder<List<AttendanceRecord>>(
        future: attendanceRecords,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final records = snapshot.data ?? [];
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
                absentCount:absentCount,
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TimetablePage(),
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
