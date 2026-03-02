import '../repositories/checkin_repository.dart';

class CheckInUseCase {
  final CheckInRepository repository;

  const CheckInUseCase(this.repository);

  Future<void> call() {
    return repository.checkIn();
  }
}
