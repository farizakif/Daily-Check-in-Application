import '../repositories/checkin_repository.dart';

class HasCheckedInToday {
  final CheckInRepository repository;

  HasCheckedInToday(this.repository);

  Future<bool> call() {
    return repository.hasCheckedInToday();
  }
}

