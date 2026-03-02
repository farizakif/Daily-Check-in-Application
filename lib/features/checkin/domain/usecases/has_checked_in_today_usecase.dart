import '../repositories/checkin_repository.dart';

class HasCheckedInTodayUseCase {
  final CheckInRepository repository;

  const HasCheckedInTodayUseCase(this.repository);

  Future<bool> call() {
    return repository.hasCheckedInToday();
  }
}
