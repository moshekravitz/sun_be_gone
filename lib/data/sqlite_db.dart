import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sun_be_gone/models/bus_route_full_data.dart';
import 'package:sun_be_gone/models/bus_routes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SQLiteDB {
  SQLiteDB.internal();
  static final SQLiteDB _instance = SQLiteDB.internal();
  factory SQLiteDB() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  initDB() async {
    //what platform are we running on?
    if (Platform.isIOS || Platform.isAndroid) {
      final String databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'demo.db');
      return await openDatabase(path, version: 1, onCreate: _onCreate);
    } else {
      // assume linux
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
      return await databaseFactory.openDatabase(inMemoryDatabasePath,
          options: OpenDatabaseOptions(
            version: 1,
            onCreate: _onCreate,
          ));
    }
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS busRoutes (
        routeId INTEGER PRIMARY KEY,
        routeShortName TEXT,
        routeLongName TEXT)
        ''');
    await db.execute('''
        CREATE TABLE IF NOT EXISTS routeQuaryData (
        routeId INTEGER PRIMARY KEY,
        departureIndex INTEGER,
        destinationIndex INTEGER,
        fullStops TEXT,
        shapeId INTEGER,
        shapeStr TEXT)
        ''');
    await db.execute('''
        CREATE TABLE IF NOT EXISTS historyIds (
        routeId INTEGER PRIMARY KEY)
    ''');
    await db.execute('''
        CREATE TABLE IF NOT EXISTS favoriteIds (
        routeId INTEGER PRIMARY KEY)
    ''');
  }
}

abstract class BusRoutesDBInterface {
  Future<int> saveBusRoute(BusRoutes busRoute);
  Future<List<BusRoutes>> getBusRoutes();
  Future<int> updateBusRoute(Map<String, dynamic> map);
  Future<int> deleteBusRoute(int id);
}

abstract class BusRoutesQuaryDBInterface {
  Future<int> saveRouteQuaryInfo(RoutesQuaryData routeQuaryData);
  Future<List<RoutesQuaryData>> getRouteQuaryInfoList();
  Future<RoutesQuaryData?> getRouteQuaryInfo(int id);
  Future<int> updateRouteQuaryInfo(Map<String, dynamic> map);
  Future<int> deleteRouteQuaryInfo(int id);
}

abstract class FavoritesIdsDBInterface {
  Future<int> saveFavoriteId(int id);
  Future<List<int>> getFavoriteIds();
  Future<int> deleteFavoriteId(int id);
}

abstract class HistoryIdsDBInterface {
  Future<int> saveHistoryId(int id);
  Future<List<int>> getHistoryIds();
  Future<int> deleteHistoryId(int id);
}

class BusRouteDB implements BusRoutesDBInterface {
  String tableName = "busRoutes";

  @override
  Future<int> saveBusRoute(BusRoutes busRoute) async {
    var dbClient = await SQLiteDB().db;
    int res = await dbClient.insert(
      tableName,
      busRoute.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return res;
  }

  @override
  Future<List<BusRoutes>> getBusRoutes() async {
    var dbClient = await SQLiteDB().db;
    var res = await dbClient.query(tableName);
    List<BusRoutes> list =
        res.isNotEmpty ? res.map((c) => BusRoutes.fromJson(c)).toList() : [];
    return list;
  }

  @override
  Future<int> updateBusRoute(Map<String, dynamic> map) async {
    var dbClient = await SQLiteDB().db;
    int res = await dbClient.update(tableName, map,
        where: "busId = ?", whereArgs: <int>[map['routeId']]);
    return res;
  }

  @override
  Future<int> deleteBusRoute(int id) async {
    var dbClient = await SQLiteDB().db;
    int res =
        await dbClient.delete(tableName, where: 'routeId = ?', whereArgs: [id]);
    return res;
  }
}

class BusRoutesQuaryDB implements BusRoutesQuaryDBInterface {
  String tableName = "routeQuaryData";

  @override
  Future<int> saveRouteQuaryInfo(RoutesQuaryData routeQuaryData) async {
    var dbClient = await SQLiteDB().db;
    int res = await dbClient.insert(
      tableName,
      routeQuaryData.toMap().map((key, value) {
        if (key == 'stops') {
          return MapEntry('stops', jsonEncode(value));
        } else if (key == 'fullStops') {
          return MapEntry('fullStops', jsonEncode(value));
        } else {
          return MapEntry(key, value.toString());
        }
      }),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    //print('stops map from save db: ${routeQuaryData.toMap()');
    return res;
  }

  @override
  Future<List<RoutesQuaryData>> getRouteQuaryInfoList() async {
    var dbClient = await SQLiteDB().db;
    var res = await dbClient.query(tableName);
    List<RoutesQuaryData> list = res.isNotEmpty
        ? res.map((c) => RoutesQuaryData.fromJson(c)).toList()
        : [];
    return list;
  }

  @override
  Future<RoutesQuaryData?> getRouteQuaryInfo(int id) async {
    var dbClient = await SQLiteDB().db;
    var res =
        await dbClient.query(tableName, where: "routeId = ?", whereArgs: [id]);
    var asdf = res.isNotEmpty ? RoutesQuaryData.fromJson(res.first) : null;

    return asdf;
  }

  @override
  Future<int> updateRouteQuaryInfo(Map<String, dynamic> map) async {
    var dbClient = await SQLiteDB().db;
    int res = await dbClient.update(tableName, map,
        where: "routeId = ?", whereArgs: <int>[map['routeId']]);
    return res;
  }

  @override
  Future<int> deleteRouteQuaryInfo(int id) async {
    var dbClient = await SQLiteDB().db;
    int res =
        await dbClient.delete(tableName, where: 'routeId = ?', whereArgs: [id]);
    return res;
  }
}

class FavoritesIdsDB implements FavoritesIdsDBInterface {
  String tableName = "favoriteIds";

  @override
  Future<int> saveFavoriteId(int id) async {
    var dbClient = await SQLiteDB().db;
    int res = await dbClient.insert(
      tableName,
      {'routeId': id},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return res;
  }

  @override
  Future<List<int>> getFavoriteIds() async {
    var dbClient = await SQLiteDB().db;
    var res = await dbClient.query(tableName);
    List<int> list =
        res.isNotEmpty ? res.map((c) => c['routeId'] as int).toList() : [];
    return list;
  }

  @override
  Future<int> deleteFavoriteId(int id) async {
    var dbClient = await SQLiteDB().db;
    int res =
        await dbClient.delete(tableName, where: 'routeId = ?', whereArgs: [id]);
    return res;
  }
}

class HistoryIdsDB implements HistoryIdsDBInterface {
  String tableName = "historyIds";

  @override
  Future<int> saveHistoryId(int id) async {
    int res;
    var dbClient = await SQLiteDB().db;
    //if there is more than 20 routes in the history, delete the oldest one
    var historyDb = await dbClient.query(tableName);
    if (historyDb.length > 20) {
      res = await dbClient.delete(tableName,
          where: 'routeId = ?', whereArgs: [historyDb.first['routeId']]);
    } else {
      res = await dbClient.insert(
        tableName,
        {'routeId': id},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    return res;
  }

  @override
  Future<List<int>> getHistoryIds() async {
    var dbClient = await SQLiteDB().db;
    var res = await dbClient.query(tableName);
    List<int> list =
        res.isNotEmpty ? res.map((c) => c['routeId'] as int).toList() : [];
    return list;
  }

  @override
  Future<int> deleteHistoryId(int id) async {
    var dbClient = await SQLiteDB().db;
    int res =
        await dbClient.delete(tableName, where: 'routeId = ?', whereArgs: [id]);
    return res;
  }
}
