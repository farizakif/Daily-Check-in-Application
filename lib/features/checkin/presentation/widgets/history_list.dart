import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/checkin_entity.dart';

class HistoryList extends StatelessWidget {
  final List<CheckIn> checkIns;

  const HistoryList({
    super.key,
    required this.checkIns,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (checkIns.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
    final checkedInCount = items.where((item) => !item.missed).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$checkedInCount / 30 days checked in',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: checkedInCount / 30,
                    minHeight: 8,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // History list
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

  List<_DailyHistoryItem> _buildDailyItems(List<CheckIn> checkIns) {
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);

    final Map<String, CheckIn> byDateKey = {};

    for (final c in checkIns) {
      final dateOnly = DateTime(c.dateTime.year, c.dateTime.month, c.dateTime.day);
      final key = _keyForDate(dateOnly);

      final existing = byDateKey[key];
      if (existing == null || c.dateTime.isAfter(existing.dateTime)) {
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
  final CheckIn? checkIn;
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
    final dateFormatter = DateFormat('EEE, d MMM y');
    final timeFormatter = DateFormat('hh:mm a');

    final hasCheckIn = item.checkIn != null;

    final title = dateFormatter.format(item.date);
    final subtitle = hasCheckIn
        ? 'Checked in at ${timeFormatter.format(item.checkIn!.dateTime)}'
        : 'Missed';

    final icon = hasCheckIn ? Icons.check_circle : Icons.cancel;

    final iconColor = hasCheckIn ? Colors.green : Colors.red;
    final subtitleColor = hasCheckIn ? theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7) : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: iconColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: subtitleColor,
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
