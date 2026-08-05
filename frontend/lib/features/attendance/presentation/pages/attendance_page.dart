import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_page_scaffold.dart';
import 'package:frontend/core/widgets/section_title.dart';

import 'package:frontend/features/attendance/data/repositories/mock_attendance_repository.dart';
import 'package:frontend/features/attendance/domain/entities/attendance_record.dart';
import 'package:frontend/features/attendance/domain/enums/attendance_status.dart';
import 'package:frontend/features/attendance/presentation/widgets/attendance_action_card.dart';
import 'package:frontend/features/attendance/presentation/widgets/attendance_insights_card.dart';
import 'package:frontend/features/attendance/presentation/widgets/attendance_summary_card.dart';
import 'package:frontend/features/attendance/presentation/widgets/attendance_record_tile.dart';

class AttendancePage extends StatefulWidget {
  final String subjectId;
  final String subjectName;

  const AttendancePage({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });
  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final MockAttendanceRepository repository = MockAttendanceRepository();

  late Future<List<AttendanceRecord>> attendanceRecords;

  Future<void> _reloadAttendance() async {
    setState(() {
      attendanceRecords = repository.getAttendanceForSubject(widget.subjectId);
    });
  }

  @override
  void initState() {
    super.initState();

    attendanceRecords = repository.getAttendanceForSubject(widget.subjectId);
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: '${widget.subjectName} Attendance',
      child: FutureBuilder<List<AttendanceRecord>>(
        future: attendanceRecords,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("No Attendance found"));
          }
          final records = snapshot.data!;

          final presentCount = records
              .where((record) => record.status == AttendanceStatus.present)
              .length;
          final absentCount = records
              .where((record) => record.status == AttendanceStatus.absent)
              .length;
          final lateCount = records
              .where((record) => record.status == AttendanceStatus.late)
              .length;

          final totalClasses = presentCount + absentCount + lateCount;
          final percentage = totalClasses == 0
              ? 0.0
              : ((presentCount + lateCount) / totalClasses) * 100;

          final sortedRecords = [...records]
            ..sort((a, b) => b.date.compareTo(a.date));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AttendanceSummaryCard(
                absentCount: absentCount,
                lateCount: lateCount,
                presentCount: presentCount,
              ),

              const SizedBox(height: 16),

              AttendanceInsightsCard(
                totalClasses: totalClasses,
                percentage: percentage,
              ),

              const SizedBox(height: 16),

              AttendanceActionCard(
                onPresent: () async {
                  await repository.markAttendance(
                    subjectId: widget.subjectId,
                    status: AttendanceStatus.present,
                  );
                  await _reloadAttendance();
                },
                onAbsent: () async {
                  await repository.markAttendance(
                    subjectId: widget.subjectId,
                    status: AttendanceStatus.absent,
                  );
                  await _reloadAttendance();
                },
                onLate: () async {
                  await repository.markAttendance(
                    subjectId: widget.subjectId,
                    status: AttendanceStatus.late,
                  );
                  await _reloadAttendance();
                },
              ),

              const SizedBox(height: 24),

              const SectionTitle(title: "Recent Attendance"),

              const SizedBox(height: 12),

              ...sortedRecords.map(
                (record) => AttendanceRecordTile(record: record),
              ),
            ],
          );
        },
      ),
    );
  }
}
