import '../entities/checkin_entity.dart';
import '../repositories/checkin_repository.dart';

class GetCheckInHistory {
  final CheckInRepository repository;

  GetCheckInHistory(this.repository);

  Future<List<CheckIn>> call({int limit = 30}) {
    return repository.getCheckInHistory(limit: limit);
  }
}

