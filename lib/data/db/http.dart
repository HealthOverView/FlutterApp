import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

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
    //String path = await getDatabasesPath() + 'GoSari.db';
    String path = (await getTemporaryDirectory()).path + '/GoSari.db';

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
            result TEXT,
            imageFileName TEXT
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

  Future<void> deleteEvent(int id) async {
    await _database.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<List<Map<String, dynamic>>> getAllEvents() async {
    return await _database.query('events');
  }

// Rest of your code...
}
