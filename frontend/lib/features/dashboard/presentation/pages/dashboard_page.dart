import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_scaffold.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/features/attendance/presentation/pages/attendance_overview_page.dart';
import 'package:frontend/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:frontend/features/dashboard/presentation/widgets/todays_classes_card.dart';
import 'package:frontend/features/dashboard/presentation/widgets/attendance_summary_card.dart';
import 'package:frontend/features/timetable/presentation/pages/timetable_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardHeader(),
          const SizedBox(height: AppSpacing.lg),
          AttendanceSummaryCard(
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
                MaterialPageRoute(builder: (_) => const TimetablePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
