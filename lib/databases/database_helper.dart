import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // 1. PATTERN SINGLETON: Membuat satu instance tunggal agar koneksi database hanya ada satu di seluruh aplikasi.
  static final DatabaseHelper instance = DatabaseHelper._init();

  // Variabel privat untuk menyimpan koneksi SQLite asli (digunakan oleh Android & iOS).
  static Database? _database;

  // WEB FALLBACK STORAGE: Tempat penyimpanan sementara data User dan Booking di memori saat dijalankan di browser (Web).
  static List<Map<String, dynamic>>? _webUsers;
  static List<Map<String, dynamic>>? _webBookings;

  // Constructor privat untuk mencegah pembuatan objek baru dari luar kelas (harus lewat DatabaseHelper.instance).
  DatabaseHelper._init();

  // GETTER DATABASE: Dipanggil setiap kali ingin berinteraksi dengan database.
  Future<Database> get database async {
    // Validasi awal: Jika dijalankan di browser, sqflite dipastikan crash, maka lempar error.
    if (kIsWeb) {
      throw UnsupportedError('sqflite does not support Web');
    }
    // Jika koneksi database sudah ada, langsung gunakan yang lama (efisiensi memori).
    if (_database != null) return _database!;

    // Jika belum ada koneksi, lakukan inisialisasi file database baru.
    _database = await _initDB('maestronesia.db');
    return _database!;
  }

  // PROSES INISIALISASI DATABASE (MOBILE)
  Future<Database> _initDB(String filePath) async {
    // Mengambil path/lokasi folder default penyimpanan internal HP untuk database.
    final dbPath = await getDatabasesPath();
    // Menggabungkan lokasi folder dengan nama file database menjadi: 'lokasi_hp/maestronesia.db'
    final path = join(dbPath, filePath);

    // Membuka database dengan konfigurasi versi tertentu.
    return await openDatabase(
      path,
      version:
          2, // Versi dinaikkan ke 2 untuk memicu skenario migrasi (onUpgrade).
      onCreate:
          _createDB, // Dipanggil pertama kali saat file database baru dibuat di HP.
      onUpgrade:
          _upgradeDB, // Dipanggil otomatis jika versi database di kode lebih tinggi dari versi di HP user.
    );
  }

  // STRUKTUR MIGRASI (Mencegah data hilang saat aplikasi diupdate)
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Jika aplikasi versi lama user di bawah versi 2, tambahkan kolom baru tanpa menghapus data yang ada.
    if (oldVersion < 2) {
      try {
        // Menyisipkan kolom baru 'notes' ke dalam tabel 'bookings' yang sudah ada.
        await db.execute('ALTER TABLE bookings ADD COLUMN notes TEXT');
      } catch (e) {
        // Ditangkap jika kolom ternyata sudah ada karena proses sebelumnya, agar aplikasi tidak crash.
      }
    }
  }

  // PEMBUATAN TABEL BARU DARI NOL
  Future<void> _createDB(Database db, int version) async {
    // Membuat tabel 'users' untuk menyimpan data akun pendaftaran.
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT, -- ID otomatis bertambah (1, 2, 3...)
        email TEXT UNIQUE,                   -- Email dikunci UNIQUE agar tidak ada email kembar terdaftar
        password TEXT,
        name TEXT,
        role TEXT
      )
    ''');

    // Membuat tabel 'bookings' untuk menyimpan riwayat pemesanan expert.
    await db.execute('''
      CREATE TABLE bookings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_email TEXT,
        expert_id INTEGER,
        expert_name TEXT,
        topic TEXT,
        date TEXT,
        time TEXT,
        status TEXT,
        price TEXT,
        notes TEXT
      )
    ''');

    // PRE-POPULATE DATA MOCK: Memasukkan data simulasi awal agar halaman history langsung terlihat ramai saat demo.
    await db.insert('bookings', {
      'user_email': 'fajar@example.com',
      'expert_id': 1,
      'expert_name': 'Prof. Dr. Hermanto',
      'topic': 'Thermal Dynamics',
      'date': 'May 10, 2024',
      'time': '09:00 AM',
      'status': 'Completed',
      'price': 'Rp 150,000',
      'notes': 'Please explain Carnot cycle details.',
    });

    await db.insert('bookings', {
      'user_email': 'fajar@example.com',
      'expert_id': 2,
      'expert_name': 'Dr. Sarah Amelia',
      'topic': 'Algorithm Review',
      'date': 'May 05, 2024',
      'time': '11:30 AM',
      'status': 'Completed',
      'price': 'Rp 120,000',
      'notes': 'Reviewing binary trees and recursion.',
    });

    await db.insert('bookings', {
      'user_email': 'fajar@example.com',
      'expert_id': 3,
      'expert_name': 'Ir. Ahmad Fauzi',
      'topic': 'Structure Analysis',
      'date': 'Apr 28, 2024',
      'time': '02:00 PM',
      'status': 'Cancelled',
      'price': 'Refunded',
      'notes': 'Reschedule due to client schedule conflict.',
    });
  }

  // ================= SIMULASI DATABASE UNTUK WEB (SHARED PREFERENCES) =================

  // Menginisialisasi list data bohongan di Web mengambil dari penyimpanan browser.
  Future<void> _initWebDB() async {
    if (_webUsers != null)
      return; // Jika memori lokal browser sudah siap, batalkan inisialisasi ulang.
    final prefs = await SharedPreferences.getInstance();

    // Ambil string teks terenkripsi JSON untuk data Users.
    final usersStr = prefs.getString('web_users');
    if (usersStr != null) {
      // Decode: Mengubah teks string JSON kembali menjadi format List asli di Dart.
      _webUsers = List<Map<String, dynamic>>.from(
        (jsonDecode(usersStr) as List).map(
          (x) => Map<String, dynamic>.from(x as Map<dynamic, dynamic>),
        ),
      );
    } else {
      _webUsers = []; // Set kosong jika belum ada user yang mendaftar di web.
    }

    // Ambil string teks terenkripsi JSON untuk data Bookings Web.
    final bookingsStr = prefs.getString('web_bookings');
    if (bookingsStr != null) {
      _webBookings = List<Map<String, dynamic>>.from(
        (jsonDecode(bookingsStr) as List).map(
          (x) => Map<String, dynamic>.from(x as Map<dynamic, dynamic>),
        ),
      );
    } else {
      // Data dummy awal default khusus versi Web (agar sinkron dengan versi mobile saat testing).
      _webBookings = [
        {
          'id': 1,
          'user_email': 'fajar@example.com',
          'expert_id': 1,
          'expert_name': 'Prof. Dr. Hermanto',
          'topic': 'Thermal Dynamics',
          'date': 'May 10, 2024',
          'time': '09:00 AM',
          'status': 'Completed',
          'price': 'Rp 150,000',
        },
        {
          'id': 2,
          'user_email': 'fajar@example.com',
          'expert_id': 2,
          'expert_name': 'Dr. Sarah Amelia',
          'topic': 'Algorithm Review',
          'date': 'May 05, 2024',
          'time': '11:30 AM',
          'status': 'Completed',
          'price': 'Rp 120,000',
        },
        {
          'id': 3,
          'user_email': 'fajar@example.com',
          'expert_id': 3,
          'expert_name': 'Ir. Ahmad Fauzi',
          'topic': 'Structure Analysis',
          'date': 'Apr 28, 2024',
          'time': '02:00 PM',
          'status': 'Cancelled',
          'price': 'Refunded',
        },
      ];
      await _saveWebBookings(); // Simpan data dummy web ini ke penyimpanan SharedPreferences browser.
    }
  }

  // Encode & Simpan List data User ke SharedPreferences Web menjadi String teks JSON.
  Future<void> _saveWebUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('web_users', jsonEncode(_webUsers));
  }

  // Encode & Simpan List data Booking ke SharedPreferences Web menjadi String teks JSON.
  Future<void> _saveWebBookings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('web_bookings', jsonEncode(_webBookings));
  }

  // ================= LOGIKA UTAMA OPERASI CRUD & AUTENTIKASI =================

  // 1. REGISTER USER
  Future<Map<String, dynamic>?> registerUser(Map<String, dynamic> user) async {
    if (kIsWeb) {
      await _initWebDB();
      final email = user['email'];
      // Validasi: Cek apakah email inputan sudah terdaftar di daftar memori web.
      final exists = _webUsers!.any((u) => u['email'] == email);
      if (exists)
        return null; // Jika email sudah terpakai, kembalikan null (Gagal register).

      final registeredUser = Map<String, dynamic>.from(user);
      registeredUser['id'] =
          _webUsers!.length +
          1; // Membuat auto-increment manual untuk versi web.
      _webUsers!.add(registeredUser);
      await _saveWebUsers(); // Simpan permanen ke lokal browser.
      return registeredUser;
    }

    // Jalur Eksekusi HP (Android/iOS) menggunakan database SQL asli.
    final db = await instance.database;
    try {
      final id = await db.insert(
        'users',
        user,
      ); // Masukkan data ke tabel 'users'.
      final registeredUser = Map<String, dynamic>.from(user);
      registeredUser['id'] = id; // Tempelkan ID asli hasil generate database.
      return registeredUser;
    } catch (e) {
      return null; // Mengembalikan null jika melanggar constraint UNIQUE (email duplikat).
    }
  }

  // 2. LOGIN USER
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    if (kIsWeb) {
      await _initWebDB();
      // Mencari data user di list web yang email dan password-nya cocok secara bersamaan.
      final matches = _webUsers!.where(
        (u) => u['email'] == email && u['password'] == password,
      );
      if (matches.isNotEmpty) {
        return matches
            .first; // Jika ketemu di pendaftaran web, kembalikan user tersebut.
      }
      // Hardcode Akun Testing: Mempermudah penguji/dosen langsung login tanpa register saat di web.
      if (email == 'fajar@example.com' && password == 'password') {
        return {
          'id': 9999,
          'email': 'fajar@example.com',
          'password': 'password',
          'name': 'Fajar Ramadhan',
          'role': 'client',
        };
      }
      return null; // Login gagal.
    }

    // Jalur Eksekusi HP (Android/iOS) menggunakan Query SQL Terproteksi.
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where:
          'email = ? AND password = ?', // Menggunakan tanda tanya (?) demi mencegah celah keamanan SQL Injection.
      whereArgs: [
        email,
        password,
      ], // Nilai asli dipisahkan dan dimasukkan ke sini sebagai argumen aman.
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    // Akun testing cadangan untuk versi HP (Mobile).
    if (email == 'fajar@example.com' && password == 'password') {
      return {
        'id': 9999,
        'email': 'fajar@example.com',
        'password': 'password',
        'name': 'Fajar Ramadhan',
        'role': 'client',
      };
    }
    return null;
  }

  // 3. CREATE BOOKING
  Future<int> createBooking(Map<String, dynamic> booking) async {
    if (kIsWeb) {
      await _initWebDB();
      final newBooking = Map<String, dynamic>.from(booking);
      final id =
          _webBookings!.length + 1; // Membuat ID unik manual di list web.
      newBooking['id'] = id;
      _webBookings!.add(newBooking);
      await _saveWebBookings();
      return id; // Mengembalikan angka ID data baru.
    }

    final db = await instance.database;
    return await db.insert(
      'bookings',
      booking,
    ); // Menambahkan pesanan baru ke tabel 'bookings'.
  }

  // 4. READ BOOKINGS (Mengambil daftar pesanan milik user tertentu)
  Future<List<Map<String, dynamic>>> getBookings(String userEmail) async {
    if (kIsWeb) {
      await _initWebDB();
      // Menyaring list data booking yang kolom 'user_email'-nya cocok dengan email user login.
      final list = _webBookings!
          .where((b) => b['user_email'] == userEmail)
          .toList();
      // Melakukan sorting terbalik di Web agar data ID paling besar (terbaru) muncul paling atas.
      list.sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));
      return list;
    }

    final db = await instance.database;
    return await db.query(
      'bookings',
      where: 'user_email = ?',
      whereArgs: [userEmail],
      orderBy:
          'id DESC', // 'id DESC' memastikan data terbaru ditaruh paling atas pada list UI mobile.
    );
  }

  // 5. UPDATE BOOKING
  Future<int> updateBooking(int id, Map<String, dynamic> booking) async {
    if (kIsWeb) {
      await _initWebDB();
      // Menemukan indeks urutan elemen di dalam list berdasarkan ID data yang dicari.
      final index = _webBookings!.indexWhere((b) => b['id'] == id);
      if (index != -1) {
        final updated = Map<String, dynamic>.from(_webBookings![index]);
        updated.addAll(
          booking,
        ); // Menggabungkan/menimpa nilai lama dengan Map data perubahan baru.
        _webBookings![index] = updated;
        await _saveWebBookings();
        return 1; // Mengembalikan angka 1 menandakan sukses memodifikasi data.
      }
      return 0; // Gagal menemukan data.
    }

    final db = await instance.database;
    return await db.update(
      'bookings',
      booking,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 6. DELETE BOOKING
  Future<int> deleteBooking(int id) async {
    if (kIsWeb) {
      await _initWebDB();
      final index = _webBookings!.indexWhere((b) => b['id'] == id);
      if (index != -1) {
        _webBookings!.removeAt(
          index,
        ); // Menghapus item dari list web berdasarkan posisi indeksnya.
        await _saveWebBookings();
        return 1; // Sukses terhapus.
      }
      return 0;
    }

    final db = await instance.database;
    return await db.delete('bookings', where: 'id = ?', whereArgs: [id]);
  }
}
