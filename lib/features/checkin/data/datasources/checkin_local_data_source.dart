import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/date_utils.dart';
import '../models/checkin_model.dart';

abstract class CheckInLocalDataSource {
  Future<List<CheckInModel>> getCheckIns();
  Future<void> saveCheckIns(List<CheckInModel> checkIns);
  Future<void> addCheckIn(CheckInModel checkIn);
}

const String _checkInListKey = 'CHECKIN_LIST';

class CheckInLocalDataSourceImpl implements CheckInLocalDataSource {
  final SharedPreferences sharedPreferences;

  CheckInLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CheckInModel>> getCheckIns() async {
    try {
      final jsonString = sharedPreferences.getString(_checkInListKey);
      if (jsonString == null || jsonString.isEmpty) {
        return <CheckInModel>[];
      }

      final dynamic decoded = json.decode(jsonString);

      if (decoded is! List) {
        await sharedPreferences.remove(_checkInListKey);
        return <CheckInModel>[];
      }

      final List<CheckInModel> checkIns = decoded
          .whereType<Map<String, dynamic>>()
          .map<CheckInModel>((jsonMap) => CheckInModel.fromJson(jsonMap))
          .toList();

      final filtered = checkIns.where((c) {
        try {
          AppDateUtils.dateOnly(c.date);
          return true;
        } catch (_) {
          return false;
        }
      }).toList();

      return filtered;
    } on FormatException catch (e) {
      throw CacheException('Failed to parse stored check-ins: $e');
    } catch (e) {
      throw CacheException('Unexpected error reading check-ins: $e');
    }
  }

  @override
  Future<void> saveCheckIns(List<CheckInModel> checkIns) async {
    try {
      final List<Map<String, dynamic>> jsonList =
          checkIns.map((checkIn) => checkIn.toJson()).toList();
      final jsonString = json.encode(jsonList);
      final success = await sharedPreferences.setString(_checkInListKey, jsonString);
      if (!success) {
        throw CacheException('Failed to persist check-ins');
      }
    } catch (e) {
      throw CacheException('Failed to save check-ins: $e');
    }
  }

  @override
  Future<void> addCheckIn(CheckInModel checkIn) async {
    final current = await getCheckIns();
    final updated = List<CheckInModel>.from(current)..add(checkIn);
    await saveCheckIns(updated);
  }
}
