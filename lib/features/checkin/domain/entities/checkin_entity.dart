import 'package:equatable/equatable.dart';

class CheckIn extends Equatable {
  final int? id;
  final DateTime dateTime;

  const CheckIn({
    this.id,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [id, dateTime];
}

