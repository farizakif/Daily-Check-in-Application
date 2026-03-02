import 'package:equatable/equatable.dart';

import '../../domain/entities/checkin_entity.dart';

abstract class CheckInState extends Equatable {
  const CheckInState();

  @override
  List<Object?> get props => [];
}

class CheckInInitial extends CheckInState {
  const CheckInInitial();
}

class CheckInLoading extends CheckInState {
  const CheckInLoading();
}

class CheckInLoaded extends CheckInState {
  final List<CheckInEntity> checkIns;
  final bool hasCheckedInToday;

  const CheckInLoaded({
    required this.checkIns,
    required this.hasCheckedInToday,
  });

  CheckInLoaded copyWith({
    List<CheckInEntity>? checkIns,
    bool? hasCheckedInToday,
  }) {
    return CheckInLoaded(
      checkIns: checkIns ?? this.checkIns,
      hasCheckedInToday: hasCheckedInToday ?? this.hasCheckedInToday,
    );
  }

  @override
  List<Object?> get props => [checkIns, hasCheckedInToday];
}

class CheckInError extends CheckInState {
  final String message;

  const CheckInError(this.message);

  @override
  List<Object?> get props => [message];
}
