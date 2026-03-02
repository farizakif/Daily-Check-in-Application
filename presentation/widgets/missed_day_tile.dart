import 'package:flutter/material.dart';

import '../../core/utils/date_utils.dart';

class MissedDayTile extends StatelessWidget {
  final DateTime date;

  const MissedDayTile({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: Colors.grey[100],
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red[50],
          child: const Icon(
            Icons.cancel_rounded,
            color: Colors.red,
          ),
        ),
        title: Text(
          DateUtilsHelper.formatHistoryDate(date),
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(
          'Missed',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.red[400],
          ),
        ),
      ),
    );
  }
}

