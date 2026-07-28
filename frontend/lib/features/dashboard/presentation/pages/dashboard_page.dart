import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_scaffold.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:frontend/features/dashboard/presentation/widgets/todays_classes_card.dart';
import 'package:frontend/features/dashboard/presentation/widgets/attendance_summary_card.dart';

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
          const AttendanceSummaryCard(),
          const SizedBox(height: AppSpacing.lg),
          const TodaysClassesCard(),
        ],
      ),
    );
  }
}
