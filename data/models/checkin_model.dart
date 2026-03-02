import '../../domain/entities/checkin.dart';

class CheckInModel extends CheckIn {
  const CheckInModel({
    int? id,
    required DateTime dateTime,
  }) : super(id: id, dateTime: dateTime);

  factory CheckInModel.fromMap(Map<String, dynamic> map) {
    return CheckInModel(
      id: map['id'] as int?,
      dateTime: DateTime.parse(map['date_time'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date_time': dateTime.toIso8601String(),
    };
  }
}

