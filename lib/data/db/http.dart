import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._();

  late Database _database;

  // Future<List<Map<String, dynamic>>> getAllEvents() async {
  //   List<Map<String, dynamic>> events = await _database.query('events');
  //   return events;
  // }


  Future<void> initDatabase() async {
    // Get the path for the database file
    String path = await getDatabasesPath() + 'GoSari.db';

    // Open the database
    _database = await openDatabase(
      path,
      version: 1, // Specify the database version
      onCreate: (db, version) {
        // Create the necessary tables if they don't exist
        db.execute('''
          CREATE TABLE events (
            id INTEGER PRIMARY KEY,
            dateTime TEXT,
            result Text,
          )
        ''');
      },
    );
  }

  Future<void> insertEvent(Map<String, dynamic> event) async {
    await _database.insert(
      'events', // Table name
      event,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Rest of your code...
}
