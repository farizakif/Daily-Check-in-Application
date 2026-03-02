import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../core/utils/date_utils.dart';
import '../models/checkin_model.dart';

abstract class CheckInLocalDataSource {
  Future<CheckInModel> insertCheckIn();
  Future<List<CheckInModel>> getAllCheckIns();
  Future<bool> hasCheckedInToday();
}

class CheckInLocalDataSourceImpl implements CheckInLocalDataSource {
  static const String _dbName = 'checkin.db';
  static const String _tableName = 'checkins';

  final Database db;

  CheckInLocalDataSourceImpl._(this.db);

  static Future<CheckInLocalDataSourceImpl> create() async {
    // Centralised database creation to keep persistence concerns below domain.
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, _dbName);

    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date_time TEXT NOT NULL
          )
        ''');
      },
    );

    return CheckInLocalDataSourceImpl._(database);
  }

  @override
  Future<CheckInModel> insertCheckIn() async {
    final now = DateTime.now();
    final model = CheckInModel(dateTime: now);

    final id = await db.insert(
      _tableName,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return CheckInModel(id: id, dateTime: now);
  }

  @override
  Future<List<CheckInModel>> getAllCheckIns() async {
    final maps = await db.query(
      _tableName,
      orderBy: 'date_time DESC',
    );

    return maps.map((m) => CheckInModel.fromMap(m)).toList();
  }

  @override
  Future<bool> hasCheckedInToday() async {
    final todayKey = DateUtilsHelper.formatDateKey(DateTime.now());
    final result = await db.query(
      _tableName,
      where: 'date(date_time) = ?',
      whereArgs: [todayKey],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}

