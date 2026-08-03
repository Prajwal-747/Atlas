import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_page_scaffold.dart';
import 'package:frontend/features/timetable/data/repositories/mock_timetable_repository.dart';
import 'package:frontend/features/timetable/domain/entities/class_session.dart';
import 'package:frontend/features/timetable/presentation/widgets/session_tile.dart';
import 'package:frontend/core/widgets/section_title.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final MockTimetableRepository timetableRepository = MockTimetableRepository();

  late Future<List<ClassSession>> sessions;

  Map<String, List<ClassSession>> groupSessionsByDay(
    List<ClassSession> sessions,
  ) {
    final grouped = <String, List<ClassSession>>{};

    for (final session in sessions) {
      final day = session.dayOfWeek.name;
      grouped.putIfAbsent(day, () => []);
      grouped[day]!.add(session);
    }

    return grouped;
  }

  @override
  void initState() {
    super.initState();
    sessions = timetableRepository.getAllSessions();
  }

  static const dayOrder = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Timetable',
      child: FutureBuilder<List<ClassSession>>(
        future: sessions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No sessions found"));
          }
          final sessionList = snapshot.data!;
          final groupedSessions = groupSessionsByDay(sessionList);
          final orderedDays = groupedSessions.entries.toList()
            ..sort(
              (a, b) =>
                  dayOrder.indexOf(a.key).compareTo(dayOrder.indexOf(b.key)),
            );
          return ListView(
            children: orderedDays.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: SectionTitle(
                      title:
                          entry.key[0].toUpperCase() + entry.key.substring(1),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...entry.value.map(
                    (session) => SessionTile(session: session),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
