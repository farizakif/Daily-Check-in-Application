import '../entities/checkin.dart';

abstract class CheckInRepository {
  Future<CheckIn> performCheckIn();
  Future<List<CheckIn>> getCheckInHistory({int limit});
  Future<bool> hasCheckedInToday();
  Future<CheckIn?> getTodayCheckIn();
}
