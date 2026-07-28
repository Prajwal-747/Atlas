import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/widgets/section_title.dart';

class TodaysClassesCard extends StatelessWidget {
  const TodaysClassesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: "Today's Classes"),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(
                  Icons.event_available_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    "No Classes scheduled today",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
