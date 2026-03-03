import 'package:flutter/material.dart';
import '../../../../core/utils/date_utils.dart';

class HistoryTile extends StatelessWidget {
  final DateTime date;
  final DateTime? checkInTime;

  const HistoryTile({
    super.key,
    required this.date,
    this.checkInTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCheckedIn = checkInTime != null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCheckedIn ? Colors.green[50] : Colors.red[50],
          child: Icon(
            isCheckedIn
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            color: isCheckedIn ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          DateUtilsHelper.formatHistoryDate(date),
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(
          isCheckedIn
              ? 'Checked in at ${DateUtilsHelper.formatTime(checkInTime!)}'
              : 'Missed',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isCheckedIn ? Colors.grey[700] : Colors.red[400],
          ),
        ),
        tileColor: isCheckedIn ? Colors.white : Colors.grey[100],
      ),
    );
  }
}

