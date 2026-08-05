import 'package:flutter/material.dart';
import 'package:frontend/features/attendance/domain/entities/attendance_record.dart';
import 'package:frontend/features/attendance/domain/enums/attendance_status.dart';

class AttendanceRecordTile extends StatelessWidget {
  final AttendanceRecord record;

  const AttendanceRecordTile({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String status;

    switch (record.status) {
      case AttendanceStatus.present:
        icon = Icons.check_circle;
        color = Colors.green;
        status = "Present";
        break;

      case AttendanceStatus.absent:
        icon = Icons.cancel;
        color = Colors.red;
        status = "Absent";
        break;

      case AttendanceStatus.late:
        icon = Icons.schedule;
        color = Colors.orange;
        status = "Late";
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(status),
        subtitle: Text(
          "${record.date.day}/${record.date.month}/${record.date.year}",
        ),
      ),
    );
  }
}
