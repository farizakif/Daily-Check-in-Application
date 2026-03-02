import 'dart:math';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/checkin_entity.dart';
import '../../domain/repositories/checkin_repository.dart';
import '../datasources/checkin_local_data_source.dart';
import '../models/checkin_model.dart';

class CheckInRepositoryImpl implements CheckInRepository {
  final CheckInLocalDataSource localDataSource;

  CheckInRepositoryImpl({required this.localDataSource});

  @override
  Future<void> checkIn() async {
    try {
      final now = DateTime.now();
      final dateOnly = AppDateUtils.dateOnly(now);

      final existing = await localDataSource.getCheckIns();

      final alreadyCheckedInToday = existing.any(
        (c) => AppDateUtils.isSameDate(c.date, dateOnly),
      );

      if (alreadyCheckedInToday) {
        throw const CacheFailure('Already checked in today');
      }

      final id = _generateId(now);

      final model = CheckInModel(
        id: id,
        date: dateOnly,
        time: now,
      );

      await localDataSource.addCheckIn(model);
    } on CacheFailure {
      rethrow;
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    } catch (e) {
      throw CacheFailure('Failed to perform check-in: $e');
    }
  }

  @override
  Future<List<CheckInEntity>> getCheckIns() async {
    try {
      final models = await localDataSource.getCheckIns();

      final sorted = List<CheckInModel>.from(models)
        ..sort((a, b) => b.time.compareTo(a.time));

      return List<CheckInEntity>.unmodifiable(sorted);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    } catch (e) {
      throw CacheFailure('Failed to load check-ins: $e');
    }
  }

  @override
  Future<bool> hasCheckedInToday() async {
    try {
      final models = await localDataSource.getCheckIns();
      final today = AppDateUtils.dateOnly(DateTime.now());

      return models.any((c) => AppDateUtils.isSameDate(c.date, today));
    } on CacheException {
      return false;
    } catch (_) {
      return false;
    }
  }

  String _generateId(DateTime time) {
    final rand = Random();
    final randomPart = rand.nextInt(1 << 32);
    return '${time.millisecondsSinceEpoch}_$randomPart';
  }
}
