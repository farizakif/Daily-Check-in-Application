import '../../../../core/utils/date_utils.dart';
import '../../domain/exceptions/checkin_exceptions.dart';
import '../../domain/entities/checkin_entity.dart';
import '../../domain/repositories/checkin_repository.dart';
import '../datasources/checkin_local_data_source.dart';

class CheckInRepositoryImpl implements CheckInRepository {
  final CheckInLocalDataSource localDataSource;

  CheckInRepositoryImpl({required this.localDataSource});

  @override
  Future<CheckIn> checkIn() => performCheckIn();

  @override
  Future<CheckIn> performCheckIn() async {
    final alreadyCheckedIn = await localDataSource.hasCheckedInToday();
    if (alreadyCheckedIn) {
      throw CheckInAlreadyDoneException();
    }
    return localDataSource.insertCheckIn();
  }

  @override
  Future<List<CheckIn>> getCheckInHistory({int limit = 30}) async {
    final list = await localDataSource.getAllCheckIns();
    return list.take(limit).toList();
  }

  @override
  Future<bool> hasCheckedInToday() {
    return localDataSource.hasCheckedInToday();
  }

  @override
  Future<CheckIn?> getTodayCheckIn() async {
    final all = await localDataSource.getAllCheckIns();
    final todayKey = DateUtilsHelper.formatDateKey(DateTime.now());
    for (final c in all) {
      if (DateUtilsHelper.formatDateKey(c.dateTime) == todayKey) {
        return c;
      }
    }
    return null;
  }
}
