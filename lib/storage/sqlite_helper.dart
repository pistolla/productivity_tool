import 'package:remotesurveyadmin/config/constants.dart';
import 'package:remotesurveyadmin/models/db_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  static final DatabaseHandler instance = DatabaseHandler._init();

  static Database? _database;

  DatabaseHandler._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dbModels.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, DB_NAME),
      onCreate: (database, version) async {
        await database.execute(
          INIT_QUERIES,
        );
      },
      version: 1,
    );
  }

  Future<DBModel> create(DBModel dbModel) async {
    final db = await instance.database;
    final id = await db.insert(dbModel.getTable(), dbModel.toJson());
    return dbModel.copy({"id": id});
  }

  Future<DBModel> readDBModel(DBModel dbModel, int id) async {
    final db = await instance.database;

    final maps = await db.query(
      dbModel.getTable(),
      columns: dbModel.getFields(),
      where: '_id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return dbModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<DBModel>> readAllDBModels(DBModel dbModel) async {
    final db = await instance.database;
    final orderBy = '_id ASC';
    final result = await db.query(dbModel.getTable(), orderBy: orderBy);
    return result.map((json) => dbModel.fromJson(json)).toList();
  }

  Future<int> updateDBModel(DBModel dbModel) async {
    final db = await instance.database;
    return db.update(
      dbModel.getTable(),
      dbModel.toJson(),
      where: '_id = ?',
      whereArgs: [dbModel.getId()],
    );
  }

  Future<int> deleteDBModel(DBModel dbModel) async {
    final db = await instance.database;
    return await db.delete(
      dbModel.getTable(),
      where: '_id = ?',
      whereArgs: [dbModel.getId()],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
