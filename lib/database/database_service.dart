import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todoapp/database/todo_db.dart';

class DatabaseService {
  Database? _database; //database value

  // database access getter
  Future<Database> get database async {
    if (_database != null) {
      return _database!; // Return the same database if it was created before
    }
    _database = await _initialize(); //If not, initialize the database
    return _database!;
  }

  // getter that returns the full path of the database file
  Future<String> get fullPath async {
    const name = 'todo.db'; // database file name
    final path =
        await getDatabasesPath(); // Get the device's path used for databases
    return join(path, name); //  Database path and name join
  }

  // Database start method
  Future<Database> _initialize() async {
    final path = await fullPath; //database file all path
    var database = await openDatabase(
      path, // database file path
      version: 1, // Database version is important for migrations
      onCreate: create, // Function to run when creating database
      singleInstance: true, // Allows use of a single instance
    );
    return database; // Return created/exported database
  }

  // Database table method
  Future<void> create(Database database, int version) async {
    await TodoDB().createTable(
        database); // The createTable function in the TodoDB class is called
  }
}
