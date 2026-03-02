import 'package:equatable/equatable.dart';

import '../../domain/entities/checkin.dart';

abstract class CheckInState extends Equatable {
  const CheckInState();

  @override
  List<Object?> get props => [];
}

class CheckInInitial extends CheckInState {}

class CheckInLoading extends CheckInState {}

class CheckInLoaded extends CheckInState {
  final bool hasCheckedInToday;
  final DateTime? todayCheckInTime;
  final int streakCount;

  const CheckInLoaded({
    required this.hasCheckedInToday,
    required this.todayCheckInTime,
    required this.streakCount,
  });

  @override
  List<Object?> get props => [hasCheckedInToday, todayCheckInTime, streakCount];
}

class CheckInSuccess extends CheckInState {
  final DateTime checkInTime;
  final int streakCount;

  const CheckInSuccess({
    required this.checkInTime,
    required this.streakCount,
  });

  @override
  List<Object?> get props => [checkInTime, streakCount];
}

class CheckInAlreadyDone extends CheckInState {
  final DateTime checkInTime;
  final int streakCount;

  const CheckInAlreadyDone({
    required this.checkInTime,
    required this.streakCount,
  });

  @override
  List<Object?> get props => [checkInTime, streakCount];
}

class CheckInHistoryLoaded extends CheckInState {
  final List<CheckIn> checkIns;
  final List<DateTime> last30Days;

  const CheckInHistoryLoaded({
    required this.checkIns,
    required this.last30Days,
  });

  @override
  List<Object?> get props => [checkIns, last30Days];
}

class CheckInError extends CheckInState {
  final String message;

  const CheckInError({required this.message});

  @override
  List<Object?> get props => [message];
}

