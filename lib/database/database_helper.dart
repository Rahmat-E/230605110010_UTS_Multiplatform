import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'todo.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Menutup koneksi database secara eksplisit
  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        title       TEXT    NOT NULL,
        description TEXT,
        isDone      INTEGER NOT NULL DEFAULT 0,
        createdAt   TEXT    NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE todos ADD COLUMN priority INTEGER DEFAULT 0',
      );
    }
  }
  // Future<void> insertTodo(Todo todo) async {
  //   final db = await database;
  //   await db.insert(
  //     'todos',
  //     todo.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }
  Future<int> insertTodo(Todo todo) async {
    try {
      final db = await database;
      return await db.insert(
        'todos',
        todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception('Tugas dengan data yang sama sudah ada.');
      }
      throw Exception('Gagal menyimpan tugas: ${e.toString()}');
    }
  }
  Future<void> insertTodoWithLog(Todo todo, String logMessage) async {
    final db = await database;
    await db.transaction((txn) async {
      // Operasi pertama: simpan tugas baru
      await txn.insert('todos', todo.toMap());

      // Operasi kedua: catat log aktivitas
      await txn.insert('activity_logs', {
        'message': logMessage,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Jika salah satu operasi di atas gagal, seluruh transaksi dibatalkan
    });
  }


// Mengambil seluruh tugas, diurutkan dari yang terbaru
  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => Todo.fromMap(maps[i]));
  }

// Mengambil satu tugas berdasarkan id
  Future<Todo?> getTodoById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return Todo.fromMap(maps.first);
  }
// Memperbarui data tugas yang sudah ada
  Future<int> updateTodo(Todo todo) async {
    final db = await database;
    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

// Menandai tugas sebagai selesai atau belum selesai
  Future<int> toggleTodoStatus(int id, bool isDone) async {
    final db = await database;
    return await db.update(
      'todos',
      {'isDone': isDone ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
// Menghapus satu tugas berdasarkan id
  Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<int> deleteCompletedTodos() async {
    final db = await database;
    return await db.delete(
      'todos',
      where: 'isDone = ?',
      whereArgs: [1],
    );
  }
// Menghapus semua tugas yang sudah selesai
  Future<int> clearCompletedTodos() async {
    final db = await database;
    return await db.delete(
      'todos',
      where: 'isDone = ?',
      whereArgs: [1],
    );
  }
//   soal nomor 4  untuk search
  Future<List<Todo>> searchTodos({
    String keyword = '',
    String filter = 'all',
  }) async {
    final db = await database;

    String where = '';
    List<dynamic> args = [];

    // Filter status
    if (filter == 'done') {
      where += 'isDone = ?';
      args.add(1);
    } else if (filter == 'undone') {
      where += 'isDone = ?';
      args.add(0);
    }

    // Search LIKE
    if (keyword.isNotEmpty) {
      if (where.isNotEmpty) where += ' AND ';
      where += 'title LIKE ?';
      args.add('%$keyword%');
    }

    final result = await db.query(
      'todos',
      where: where.isEmpty ? null 3: where,
      whereArgs: args,
      orderBy: 'id DESC',
    );

    return result.map((e) => Todo.fromMap(e)).toList();

    // final result = await db.rawQuery(
    //   '''
    //   SELECT * FROM todos
    //   ${where.isEmpty ? '' : 'WHERE $where'}
    //   ORDER BY id DESC
    //   ''',
    //   args,
    // );
    //
    // return result.map((e) => Todo.fromMap(e)).toList();
  }
}
