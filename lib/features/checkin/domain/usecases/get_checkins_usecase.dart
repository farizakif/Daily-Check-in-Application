import '../entities/checkin_entity.dart';
import '../repositories/checkin_repository.dart';

class GetCheckInsUseCase {
  final CheckInRepository repository;

  const GetCheckInsUseCase(this.repository);

  Future<List<CheckInEntity>> call() {
    return repository.getCheckIns();
  }
}
