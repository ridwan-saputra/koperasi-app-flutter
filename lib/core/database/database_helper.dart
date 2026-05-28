import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Menerapkan Singleton Pattern agar koneksi database hanya dibuka satu kali
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('koperasi.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Buka database, jika belum ada otomatis memanggil _createDB
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

Future _createDB(Database db, int version) async {
    // 1. Membuat tabel users
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        role TEXT NOT NULL,
        nik TEXT UNIQUE NOT NULL,
        nama_lengkap TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        no_hp TEXT NOT NULL,
        password_hash TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // 2. Membuat tabel transactions (Simpanan)
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        type TEXT NOT NULL,
        nominal REAL NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
    
    // 3. Akun Admin Default (Predefined)
    await db.execute('''
      INSERT INTO users (id, role, nik, nama_lengkap, email, no_hp, password_hash, created_at)
      VALUES ('admin-001', 'ADMIN', '0000000000000000', 'Administrator', 'admin@koperasi.com', '080000000000', 'admin123', '${DateTime.now().toIso8601String()}')
    ''');
  }
}
