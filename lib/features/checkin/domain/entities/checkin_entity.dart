import 'package:equatable/equatable.dart';

class CheckInEntity extends Equatable {
  final String id;
  final DateTime date;
  final DateTime time;

  const CheckInEntity({
    required this.id,
    required this.date,
    required this.time,
  });

  @override
  List<Object> get props => [id, date, time];
}
