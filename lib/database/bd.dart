import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SqlDb {
  static get title => null;

  static Future<void> createTables(sql.Database database) async {
    await database.execute(""""CREATE TABLE tutorial(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TMESTAMP
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbteste.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> insert(String title, String? descrption) async {
    final db = await SqlDb.db();

    final data = {'title': title, 'description': descrption};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> buscarTodos() async {
    final db = await SqlDb.db();
    return db.query('items', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> buscarPorItem(int id) async {
    final db = await SqlDb.db();
    return db.query('items', where: "id=?", whereArgs: [id], limite: 1);
  }

  static Future<int> atualizaItem(
      int id, String tile, String? descrption) async {
    final db = await SqlDb.db();

    final data = {
      'title': title,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };
    final result =
        await db.update('item', data, where: "id=?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SqlDb.db();
    try {
      await db.delete("items", where: "id=?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Algo deu errado na exclusão do item: $err");
    }
  }
}
