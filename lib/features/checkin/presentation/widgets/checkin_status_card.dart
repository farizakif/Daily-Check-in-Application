import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/checkin_entity.dart';

class CheckInStatusCard extends StatelessWidget {
  final bool hasCheckedInToday;
  final List<CheckInEntity> checkIns;

  const CheckInStatusCard({
    super.key,
    required this.hasCheckedInToday,
    required this.checkIns,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final todayDateOnly = AppDateUtils.dateOnly(today);

    final todayCheckIn = checkIns.firstWhere(
      (c) => AppDateUtils.isSameDate(c.date, todayDateOnly),
      orElse: () => CheckInEntity(
        id: '',
        date: DateTime.fromMillisecondsSinceEpoch(0),
        time: DateTime.fromMillisecondsSinceEpoch(0),
      ),
    );

    final hasValidToday = todayCheckIn.id.isNotEmpty;

    final titleText = hasCheckedInToday && hasValidToday
        ? 'You\'re checked in for today'
        : 'No check-in yet today';

    final subtitleText = hasCheckedInToday && hasValidToday
        ? 'Checked in at ${DateFormat('hh:mm a').format(todayCheckIn.time)}'
        : 'Tap the button below to check in and keep your habit going.';

    final icon = hasCheckedInToday && hasValidToday
        ? Icons.check_circle_rounded
        : Icons.radio_button_unchecked_rounded;

    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: hasCheckedInToday && hasValidToday
                    ? colorScheme.primary.withOpacity(0.08)
                    : colorScheme.secondary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: hasCheckedInToday && hasValidToday
                    ? colorScheme.primary
                    : colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleText,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitleText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
