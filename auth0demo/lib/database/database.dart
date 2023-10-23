import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  static final DatabaseHandler _databaseHandler = DatabaseHandler._internal();

  factory DatabaseHandler() {
    return _databaseHandler;
  }

  DatabaseHandler._internal();

  Database? database;

  Future<void> initDb() async {
    database = await openDatabase(
        join(await getDatabasesPath(), 'message_database.db'),
        version: _migrationScripts.length + 1,
        onCreate: (Database db, int version) async {
          _initialScript.forEach((script) async => await db.execute(script));
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          for (var i = oldVersion - 1; i < newVersion - 1; i++) {
            await db.execute(_migrationScripts[i]);
          }
        }
    );
  }

  static final _initialScript = [
    '''
      PRAGMA foreign_keys = ON;
    ''',
    '''
      CREATE TABLE Utilisateur (
        id TEXT PRIMARY KEY
        nom TEXT NOT NULL
      );
    ''',
    '''
      CREATE TABLE Role (
        id INTEGER PRIMARY KEY AUTOINCREMENT
        id_utilisateur TEXT,
        role TEXT NOT NULL
        FOREIGN KEY(id_utilisateur) REFERENCES Utilisateur(id)
      );
    ''',
  ];

  static final _migrationScripts = [
  ];
}