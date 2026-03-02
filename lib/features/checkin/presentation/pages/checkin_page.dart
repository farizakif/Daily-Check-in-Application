import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/checkin_bloc.dart';
import '../bloc/checkin_event.dart';
import '../bloc/checkin_state.dart';
import '../widgets/checkin_button.dart';
import '../widgets/checkin_status_card.dart';
import '../widgets/history_list.dart';

class CheckInPage extends StatelessWidget {
  const CheckInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckInBloc, CheckInState>(
      listenWhen: (previous, current) =>
          current is CheckInError ||
          (previous is CheckInLoaded &&
              current is CheckInLoaded &&
              !previous.hasCheckedInToday &&
              current.hasCheckedInToday),
      listener: (context, state) {
        if (state is CheckInError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is CheckInLoaded && state.hasCheckedInToday) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Check-in completed. Great job!')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Daily Check-In'),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<CheckInBloc>().add(const RefreshCheckInsEvent());
              },
              child: _buildBody(context, state),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CheckInState state) {
    if (state is CheckInLoading || state is CheckInInitial) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is CheckInError) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 80),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<CheckInBloc>().add(const LoadCheckInsEvent());
              },
              child: const Text('Retry'),
            ),
          ),
        ],
      );
    }

    if (state is! CheckInLoaded) {
      return const SizedBox.shrink();
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        CheckInStatusCard(
          hasCheckedInToday: state.hasCheckedInToday,
          checkIns: state.checkIns,
        ),
        const SizedBox(height: 16),
        CheckInButton(
          hasCheckedInToday: state.hasCheckedInToday,
          onPressed: () {
            context.read<CheckInBloc>().add(const PerformCheckInEvent());
          },
        ),
        const SizedBox(height: 24),
        HistoryList(checkIns: state.checkIns),
        const SizedBox(height: 16),
      ],
    );
  }
}
