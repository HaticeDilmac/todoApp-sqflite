import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todoapp/database/todo_db.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'todo.db'; //database name
    final path = await getDatabasesPath(); //database route
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(path,
        version: 1, onCreate: create, singleInstance: true);
    return database;
  }

  Future<void> create(Database database, int version) async {
    await TodoDB().createTable(database);
  }
}


// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:todo_app/database/todo_db.dart';

// class DatabaseService {
//   Database? _database;

//   Future<Database> get database async {
//     if (_database != null) {
//       return _database!;
//     }
//     _database = await _initialize();
//     return _database!;
//   }

//   Future<String> get fullPath async {
//     const name = 'todo.db'; // database name
//     final path = await getDatabasesPath(); // database route
//     return join(path, name);
//   }

//   Future<Database> _initialize() async {
//     final path = await fullPath;
//     var database = await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         // Burada tablo oluşturma sorgusu doğrudan veriliyor
//         await db.execute('''
//           CREATE TABLE IF NOT EXISTS todos (
//             "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
//             "title" TEXT NOT NULL,
//             "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s','now') as int)),
//             "updated_at" INTEGER
//           );
//         ''');
//       },
//       singleInstance: true, // Tek bir instance kullanılması sağlanır
//     );
//     return database;
//   }
// }
