import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_flutter/model/DataModel.dart';

class DatabaseHelper {
  static const _databaseName = 'person.db';
  static const _databaseVersion = 3;

  static const databaseTable = 'person_table';
  static const columnId = 'columnId';
  static const columnName = 'columnName';
  static const columnAge = 'columnAge';

  static String createTableSql = '''
              CREATE TABLE $databaseTable(
                $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
                 $columnName TEXT NOT NULL,
                  $columnAge TEXT NOT NULL
                  )
                ''';
  static Database? _database;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(join(path, _databaseName),
        onCreate: _onCreate, version: _databaseVersion);
  }

  _onCreate(Database database, version) async {
    await database.execute('''
    CREATE TABLE $databaseTable(
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
     $columnName TEXT NOT NULL,
      $columnAge TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertData(DataModel dataModel) async {
    final database = await DatabaseHelper.instance.database;
    return database.insert(databaseTable, dataModel.toJson());
  }

  Future<List<DataModel>> getData() async {
    final database = await DatabaseHelper.instance.database;
    final List<Map<String, Object?>> data = await database.query(databaseTable);
    return data.map((e) => DataModel.fromJson(e)).toList();
  }

  Future<void> updateData(DataModel dataModel, int id) async {
    final database = await DatabaseHelper.instance.database;
    await database.update(databaseTable, dataModel.toJson(),
        where: "id=?", whereArgs: [id]);
  }

  Future<void> deleteData(int id) async {
    final database = await DatabaseHelper.instance.database;
    await database
        .delete(databaseTable, where: "$columnId = ?", whereArgs: [id]);
  }
}
