import 'package:sqflite/sqlite_api.dart';
import 'package:todoapp/database/database_service.dart';

import '../model/todo.dart';

class TodoDB {
  final tableName = 'todos';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
       "id"  INTEGER NOT NULL,
       "title" TEXT NOT NULL,
        "created_at"  INTEGER NOT NULL DEFAULT (cast(strftime('%s','now') as int))
        "updated_at" INTEGER,
        PRIMARY KEY("id"  AUTOINCREAMENT)
      );""");
  }

  Future<int> create({required String title}) async {
    final database = await DatabaseService().database; //connect database
    return await database.rawInsert(
      '''INSERT INTO $tableName (title,created_at) VALUES (?,?)''', //table data insert code
      [title, DateTime.now().millisecondsSinceEpoch],
    );
  }

  Future<List<ToDo>> fetchAll() async {
    final database = await DatabaseService().database; //connect database
    final todos = await database.rawQuery(
        '''SELECT* from $tableName ORDER BY COALESCE(updated_at,created_at)''');
    return todos.map((todo) => ToDo.fromSqfliteDatabase(todo)).toList();
  }

  Future<ToDo> fetchById(int id) async {
    final database = await DatabaseService().database; //connect database
    final todo = await database
        .rawQuery('''SELECT * from $tableName WHERE id = ?''', [id]);
    return ToDo.fromSqfliteDatabase(todo.first);
  }

  Future<int> update({required int id, String? title}) async {
    final database = await DatabaseService().database; //connect database
    return await database.update(
        tableName,
        {
          if (title != null) 'title': title,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'id = ?',
        conflictAlgorithm: ConflictAlgorithm.rollback,
        whereArgs: [id]);
  }

  Future<void> delete(int id) async {
    final database = await DatabaseService().database; //connect database
    await database.rawDelete('''DELETE FROM $tableName WHERE id= ?''',[id]);
  }
}
