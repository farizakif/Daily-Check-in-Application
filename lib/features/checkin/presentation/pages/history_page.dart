import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/checkin_bloc.dart';
import '../bloc/checkin_event.dart';
import '../bloc/checkin_state.dart';
import '../widgets/history_list.dart';

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
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: HistoryList(checkIns: state.checkIns),
                ),
              );
            }

            if (state is CheckInLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: HistoryList(checkIns: state.checkIns),
                ),
              );
            }

            return const Center(
              child: Text('No history available'),
            );
          },
        ),
      ),
    );
  }
}
