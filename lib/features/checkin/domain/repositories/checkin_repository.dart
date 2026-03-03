import '../entities/checkin_entity.dart';

abstract class CheckInRepository {
  Future<CheckIn> performCheckIn();
  Future<CheckIn> checkIn() => performCheckIn(); // Alias
  Future<List<CheckIn>> getCheckInHistory({int limit});
  Future<bool> hasCheckedInToday();
  Future<CheckIn?> getTodayCheckIn();
}
