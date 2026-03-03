import '../entities/checkin_entity.dart';
import '../repositories/checkin_repository.dart';

class PerformCheckIn {
  final CheckInRepository repository;

  PerformCheckIn(this.repository);

  Future<CheckIn> call() {
    return repository.performCheckIn();
  }
}

