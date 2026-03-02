import 'package:equatable/equatable.dart';

abstract class CheckInEvent extends Equatable {
  const CheckInEvent();

  @override
  List<Object?> get props => [];
}

class LoadCheckInsEvent extends CheckInEvent {
  const LoadCheckInsEvent();
}

class PerformCheckInEvent extends CheckInEvent {
  const PerformCheckInEvent();
}

class RefreshCheckInsEvent extends CheckInEvent {
  const RefreshCheckInsEvent();
}
