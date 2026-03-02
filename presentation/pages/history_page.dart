import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/date_utils.dart';
import '../../domain/entities/checkin.dart';
import '../bloc/checkin_bloc.dart';
import '../bloc/checkin_event.dart';
import '../bloc/checkin_state.dart';
import '../widgets/history_tile.dart';
import '../widgets/missed_day_tile.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<CheckInBloc>().add(const LoadHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-In History'),
      ),
      body: SafeArea(
        child: BlocBuilder<CheckInBloc, CheckInState>(
          builder: (context, state) {
            if (state is CheckInLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CheckInHistoryLoaded) {
              final checkInsByDate = <String, CheckIn>{};
              for (final c in state.checkIns) {
                final key = DateUtilsHelper.formatDateKey(c.dateTime);
                checkInsByDate[key] = c;
              }

              int checkedCount = 0;
              final items = <Widget>[];

              for (final date in state.last30Days) {
                final key = DateUtilsHelper.formatDateKey(date);
                final checkIn = checkInsByDate[key];
                if (checkIn != null) {
                  checkedCount++;
                  items.add(
                    HistoryTile(
                      date: date,
                      checkInTime: checkIn.dateTime,
                    ),
                  );
                } else {
                  items.add(
                    MissedDayTile(date: date),
                  );
                }
              }

              final ratio = checkedCount / state.last30Days.length;

              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$checkedCount / 30 days checked in',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: LinearProgressIndicator(
                                value: ratio,
                                backgroundColor: Colors.grey[200],
                                color: Colors.teal,
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: state.checkIns.isEmpty
                        ? _EmptyHistory()
                        : ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) => items[index],
                          ),
                  ),
                ],
              );
            }

            if (state is CheckInError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Colors.red,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<CheckInBloc>()
                              .add(const LoadHistory());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.insert_chart_outlined_rounded,
              size: 72,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No history yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Your next check-in will start a 30-day view of your habits.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

