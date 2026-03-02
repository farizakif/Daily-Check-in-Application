import 'package:equatable/equatable.dart';

abstract class CheckInEvent extends Equatable {
  const CheckInEvent();

  @override
  List<Object?> get props => [];
}

class LoadCheckInStatus extends CheckInEvent {
  const LoadCheckInStatus();
}

class PerformCheckInEvent extends CheckInEvent {
  const PerformCheckInEvent();
}

class LoadHistory extends CheckInEvent {
  const LoadHistory();
}

