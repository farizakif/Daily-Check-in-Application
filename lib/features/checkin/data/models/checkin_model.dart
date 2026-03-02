import '../../domain/entities/checkin_entity.dart';

class CheckInModel extends CheckInEntity {
  const CheckInModel({
    required super.id,
    required super.date,
    required super.time,
  });

  factory CheckInModel.fromJson(Map<String, dynamic> json) {
    final dateString = json['date'] as String?;
    final timeString = json['time'] as String?;

    if (dateString == null || timeString == null) {
      throw const FormatException('Invalid CheckInModel JSON: missing date/time');
    }

    final date = DateTime.parse(dateString);
    final time = DateTime.parse(timeString);

    final id = json['id'] as String? ?? '${date.millisecondsSinceEpoch}_${time.millisecondsSinceEpoch}';

    return CheckInModel(
      id: id,
      date: date,
      time: time,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
    };
  }

  CheckInModel copyWith({
    String? id,
    DateTime? date,
    DateTime? time,
  }) {
    return CheckInModel(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }
}
