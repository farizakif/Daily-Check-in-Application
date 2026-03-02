import '../entities/checkin.dart';
import '../repositories/checkin_repository.dart';

class GetTodayCheckIn {
  final CheckInRepository repository;

  GetTodayCheckIn(this.repository);

  Future<CheckIn?> call() {
    return repository.getTodayCheckIn();
  }
}
