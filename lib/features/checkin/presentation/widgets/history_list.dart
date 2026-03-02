import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/checkin_entity.dart';

class HistoryList extends StatelessWidget {
  final List<CheckInEntity> checkIns;

  const HistoryList({
    super.key,
    required this.checkIns,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final title = Text(
      'History (last 30 days)',
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );

    if (checkIns.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No check-ins yet. Start today!',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      );
    }

    final items = _buildDailyItems(checkIns);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: 8),
        ListView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = items[index];
            return _HistoryCard(item: item);
          },
        ),
      ],
    );
  }

  List<_DailyHistoryItem> _buildDailyItems(List<CheckInEntity> checkIns) {
    final today = DateTime.now();
    final todayDateOnly = AppDateUtils.dateOnly(today);

    final Map<String, CheckInEntity> byDateKey = {};

    for (final c in checkIns) {
      final dateOnly = AppDateUtils.dateOnly(c.date);
      final key = _keyForDate(dateOnly);

      final existing = byDateKey[key];
      if (existing == null || c.time.isAfter(existing.time)) {
        byDateKey[key] = c;
      }
    }

    final List<_DailyHistoryItem> items = [];

    for (int i = 0; i < 30; i++) {
      final date = todayDateOnly.subtract(Duration(days: i));
      final key = _keyForDate(date);
      final checkIn = byDateKey[key];

      items.add(
        _DailyHistoryItem(
          date: date,
          checkIn: checkIn,
          missed: checkIn == null,
        ),
      );
    }

    return items;
  }

  String _keyForDate(DateTime date) => '${date.year}-${date.month}-${date.day}';
}

class _DailyHistoryItem {
  final DateTime date;
  final CheckInEntity? checkIn;
  final bool missed;

  const _DailyHistoryItem({
    required this.date,
    required this.checkIn,
    required this.missed,
  });
}

class _HistoryCard extends StatelessWidget {
  final _DailyHistoryItem item;

  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormatter = DateFormat('EEE, MMM d, y');
    final timeFormatter = DateFormat('hh:mm a');

    final hasCheckIn = item.checkIn != null;

    final title = dateFormatter.format(item.date);
    final subtitle = hasCheckIn
        ? 'Checked in at ${timeFormatter.format(item.checkIn!.time)}'
        : 'Missed';

    final icon = hasCheckIn ? Icons.check_circle_outline : Icons.cancel_outlined;

    final colorScheme = theme.colorScheme;

    final iconColor = hasCheckIn ? colorScheme.primary : colorScheme.error;
    final chipColor = hasCheckIn
        ? colorScheme.primary.withOpacity(0.08)
        : colorScheme.error.withOpacity(0.06);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: chipColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
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
