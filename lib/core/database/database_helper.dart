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
    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE transactions ADD COLUMN loan_id TEXT REFERENCES loans (id)',
      );
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE user_bank_accounts (
          id TEXT PRIMARY KEY,
          user_id TEXT NOT NULL,
          bank_code TEXT NOT NULL,
          bank_name TEXT NOT NULL,
          account_number TEXT NOT NULL,
          account_holder TEXT NOT NULL,
          is_primary INTEGER NOT NULL DEFAULT 1,
          created_at TEXT NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
        )
      ''');
      await db.execute('ALTER TABLE transactions ADD COLUMN bank_code TEXT');
      await db.execute('ALTER TABLE transactions ADD COLUMN bank_name TEXT');
      await db.execute('ALTER TABLE transactions ADD COLUMN account_number TEXT');
      await db.execute('ALTER TABLE transactions ADD COLUMN account_holder TEXT');
    }
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
        loan_id TEXT,
        bank_code TEXT,
        bank_name TEXT,
        account_number TEXT,
        account_holder TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (loan_id) REFERENCES loans (id) ON DELETE SET NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user_bank_accounts (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        bank_code TEXT NOT NULL,
        bank_name TEXT NOT NULL,
        account_number TEXT NOT NULL,
        account_holder TEXT NOT NULL,
        is_primary INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 3. Membuat tabel loans (Pinjaman)
    await db.execute('''
      CREATE TABLE loans (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        nominal_pokok REAL NOT NULL,
        tenor_bulan INTEGER NOT NULL,
        bunga_persen REAL NOT NULL,
        biaya_admin REAL NOT NULL,
        total_bayar REAL NOT NULL,
        cicilan_per_bulan REAL NOT NULL,
        agunan_detail TEXT,
        alamat_tinggal TEXT NOT NULL,
        pekerjaan TEXT NOT NULL,
        total_pendapatan REAL NOT NULL,
        rekening_tujuan TEXT NOT NULL,
        ktp_image_path TEXT NOT NULL,
        selfie_image_path TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 4. Membuat tabel admin_actions (Audit Trail)
    await db.execute('''
      CREATE TABLE admin_actions (
        id TEXT PRIMARY KEY,
        admin_id TEXT NOT NULL,
        loan_id TEXT NOT NULL,
        action TEXT NOT NULL,
        remarks TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (admin_id) REFERENCES users (id),
        FOREIGN KEY (loan_id) REFERENCES loans (id) ON DELETE CASCADE
      )
    ''');
    
    // ... (Kode INSERT akun Admin Default) ...
    
    // 3. Akun Admin Default (Predefined)
    await db.execute('''
      INSERT INTO users (id, role, nik, nama_lengkap, email, no_hp, password_hash, created_at)
      VALUES ('admin-001', 'ADMIN', '0000000000000000', 'Administrator', 'admin@koperasi.com', '080000000000', 'admin123', '${DateTime.now().toIso8601String()}')
    ''');
  }
}
