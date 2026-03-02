import '../entities/checkin_entity.dart';

abstract class CheckInRepository {
  Future<void> checkIn();
  Future<List<CheckInEntity>> getCheckIns();
  Future<bool> hasCheckedInToday();
}
