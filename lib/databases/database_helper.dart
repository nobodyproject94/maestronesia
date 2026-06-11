import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'preference_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// =========================================================================
// DATABASEHELPER ADALAH KELAS PEMBANTU UNTUK MENGELOLA SEMUA TRANSAKSI DATABASE SQLITE LOKAL.
// MENGGUNAKAN POLA SINGLETON UNTUK MEMASTIKAN HANYA ADA SATU INSTANCE DATABASE YANG TERBUKA DI APLIKASI.
// =========================================================================
class DatabaseHelper {
  // =========================================================================
  // INSTANCE STATIS TUNGGAL UNTUK DIAKSES SECARA GLOBAL (DATABASEHELPER.INSTANCE).
  // =========================================================================
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // =========================================================================
  // VARIABEL PENAMPUNG FALLBACK UNTUK SIMULASI DATABASE DI FLUTTER WEB (MENGGUNAKAN SHAREDPREFERENCES).
  // =========================================================================
  static List<Map<String, dynamic>>? _webUsers;
  static List<Map<String, dynamic>>? _webBookings;

  // =========================================================================
  // KONSTRUKTOR PRIVAT UNTUK MENCEGAH PEMBUATAN INSTANCE BARU SECARA LANGSUNG DARI LUAR KELAS.
  // =========================================================================
  DatabaseHelper._init();

  // =========================================================================
  // GETTER ASINKRONUS UNTUK MENGAMBIL INSTANCE DATABASE SQLITE YANG AKTIF.
  // JIKA DATABASE BELUM DIBUAT, IA AKAN MELAKUKAN INISIALISASI TERLEBIH DAHULU.
  // =========================================================================
  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError('sqflite does not support Web');
    }
    if (_database != null) return _database!;
    _database = await _initDB('maestronesia.db');
    return _database!;
  }

  // =========================================================================
  // MENGINISIALISASI KONEKSI DATABASE SQLITE DENGAN NAMA FILE YANG DITENTUKAN.
  // =========================================================================
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // MENDAPATKAN FOLDER PENYIMPANAN DATABASE LOKAL PADA PERANGKAT.
    final path = join(dbPath, filePath); // MENGGABUNGKAN FOLDER PATH DENGAN NAMA FILE DATABASE.
    return await openDatabase(
      path,
      version: 2, // VERSI DATABASE UNTUK MENGELOLA SKEMA MIGRASI JIKA ADA PERUBAHAN.
      onCreate: _createDB, // FUNGSI CALLBACK YANG DIJALANKAN SAAT DATABASE PERTAMA KALI DIBUAT.
      onUpgrade: _upgradeDB, // FUNGSI CALLBACK UNTUK MEMPERBARUI SKEMA DATABASE SAAT VERSI DINAIKKAN.
    );
  }

  // =========================================================================
  // MELAKUKAN MIGRASI/UPDATE STRUKTUR TABEL JIKA TERJADI PENINGKATAN VERSI DATABASE.
  // =========================================================================
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        // =========================================================================
        // MENAMBAHKAN KOLOM BARU 'NOTES' KE TABEL BOOKINGS UNTUK MIGRASI KE VERSI 2.
        // =========================================================================
        await db.execute('ALTER TABLE bookings ADD COLUMN notes TEXT');
      } catch (e) {
        // =========================================================================
        // ABAIKAN JIKA KOLOM TERNYATA SUDAH ADA.
        // =========================================================================
      }
    }
  }

  // =========================================================================
  // MEMBUAT TABEL-TABEL BARU SAAT DATABASE PERTAMA KALI DIINISIALISASI.
  // =========================================================================
  Future<void> _createDB(Database db, int version) async {
    // =========================================================================
    // MEMBUAT TABEL 'USERS' UNTUK MENYIMPAN AKUN PENGGUNA (CLIENT / EXPERT).
    // =========================================================================
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT,
        name TEXT,
        role TEXT
      )
    ''');

    // =========================================================================
    // MEMBUAT TABEL 'BOOKINGS' UNTUK MENYIMPAN TRANSAKSI PESANAN KONSULTASI.
    // =========================================================================
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

    // =========================================================================
    // MEMASUKKAN BEBERAPA DATA BOOKING AWAL (DUMMY DATA) AGAR LAYAR RIWAYAT KONSULTASI TERLIHAT AKTIF PADA PERCOBAAN PERTAMA.
    // =========================================================================
    await db.insert('bookings', {
      'user_email': 'fajar@example.com',
      'expert_id': 1,
      'expert_name': 'Prof. Dr. Hermanto',
      'topic': 'Thermal Dynamics',
      'date': 'May 10, 2024',
      'time': '09:00 AM',
      'status': 'Completed',
      'price': 'Rp 150,000',
      'notes': 'Please explain Carnot cycle details.'
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
      'notes': 'Reviewing binary trees and recursion.'
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
      'notes': 'Reschedule due to client schedule conflict.'
    });
  }

  // =========================================================================
  // FUNGSI SIMULASI UNTUK INISIALISASI DATABASE DI WEB MENGGUNAKAN SHAREDPREFERENCES.
  // =========================================================================
  Future<void> _initWebDB() async {
    if (_webUsers != null) return;
    final prefs = await PreferenceHandler.prefs;
    
    // =========================================================================
    // MEMUAT DATA PENGGUNA WEB YANG DISIMPAN SEBAGAI FORMAT STRING JSON.
    // =========================================================================
    final usersStr = prefs.getString('web_users');
    if (usersStr != null) {
      _webUsers = List<Map<String, dynamic>>.from(
        (jsonDecode(usersStr) as List).map((x) => Map<String, dynamic>.from(x as Map))
      );
    } else {
      _webUsers = [];
    }

    // =========================================================================
    // MEMUAT DATA BOOKING WEB.
    // =========================================================================
    final bookingsStr = prefs.getString('web_bookings');
    if (bookingsStr != null) {
      _webBookings = List<Map<String, dynamic>>.from(
        (jsonDecode(bookingsStr) as List).map((x) => Map<String, dynamic>.from(x as Map))
      );
    } else {
      // =========================================================================
      // DATA DUMMY DEFAULT UNTUK SIMULASI BOOKING DI WEB.
      // =========================================================================
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
          'price': 'Rp 150,000'
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
          'price': 'Rp 120,000'
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
          'price': 'Refunded'
        }
      ];
      await _saveWebBookings();
    }
  }

  // =========================================================================
  // MENYIMPAN LIST PENGGUNA WEB SIMULASI KE SHAREDPREFERENCES.
  // =========================================================================
  Future<void> _saveWebUsers() async {
    final prefs = await PreferenceHandler.prefs;
    await prefs.setString('web_users', jsonEncode(_webUsers));
  }

  // =========================================================================
  // MENYIMPAN LIST BOOKING WEB SIMULASI KE SHAREDPREFERENCES.
  // =========================================================================
  Future<void> _saveWebBookings() async {
    final prefs = await PreferenceHandler.prefs;
    await prefs.setString('web_bookings', jsonEncode(_webBookings));
  }

  // =========================================================================
  // MENDAFTARKAN PENGGUNA BARU (MENYIMPANNYA KE SQLITE / SHAREDPREFERENCES WEB).
  // =========================================================================
  Future<Map<String, dynamic>?> registerUser(Map<String, dynamic> user) async {
    if (kIsWeb) {
      await _initWebDB();
      final email = user['email'];
      final exists = _webUsers!.any((u) => u['email'] == email);
      if (exists) return null; // EMAIL SUDAH TERDAFTAR.
      final registeredUser = Map<String, dynamic>.from(user);
      registeredUser['id'] = _webUsers!.length + 1;
      _webUsers!.add(registeredUser);
      await _saveWebUsers();
      return registeredUser;
    }

    final db = await instance.database;
    try {
      final id = await db.insert('users', user);
      final registeredUser = Map<String, dynamic>.from(user);
      registeredUser['id'] = id;
      return registeredUser;
    } catch (e) {
      return null;
    }
  }

  // =========================================================================
  // MELAKUKAN LOGIN PENGGUNA DENGAN MENCOCOKKAN EMAIL DAN PASSWORD.
  // =========================================================================
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    if (kIsWeb) {
      await _initWebDB();
      final matches = _webUsers!.where(
        (u) => u['email'] == email && u['password'] == password,
      );
      if (matches.isNotEmpty) {
        return matches.first;
      }
      // =========================================================================
      // AKUN SIMULASI DEFAULT JIKA DICOBA DI WEB.
      // =========================================================================
      if (email == 'fajar@example.com' && password == 'password') {
        return {
          'id': 9999,
          'email': 'fajar@example.com',
          'password': 'password',
          'name': 'Fajar Ramadhan',
          'role': 'client'
        };
      }
      return null;
    }

    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    // =========================================================================
    // AKUN SIMULASI DEFAULT JIKA SQLITE KOSONG.
    // =========================================================================
    if (email == 'fajar@example.com' && password == 'password') {
      return {
        'id': 9999,
        'email': 'fajar@example.com',
        'password': 'password',
        'name': 'Fajar Ramadhan',
        'role': 'client'
      };
    }
    return null;
  }

  // =========================================================================
  // MEMBUAT PESANAN BOOKING BARU DAN MENYIMPANNYA KE DATABASE.
  // =========================================================================
  Future<int> createBooking(Map<String, dynamic> booking) async {
    if (kIsWeb) {
      await _initWebDB();
      final newBooking = Map<String, dynamic>.from(booking);
      final id = _webBookings!.length + 1;
      newBooking['id'] = id;
      _webBookings!.add(newBooking);
      await _saveWebBookings();
      return id;
    }

    final db = await instance.database;
    return await db.insert('bookings', booking);
  }

  // =========================================================================
  // MENGAMBIL DAFTAR SEMUA BOOKING BERDASARKAN EMAIL USER (DIURUTKAN DARI PEMESANAN TERBARU).
  // =========================================================================
  Future<List<Map<String, dynamic>>> getBookings(String userEmail) async {
    if (kIsWeb) {
      await _initWebDB();
      final list = _webBookings!.where((b) => b['user_email'] == userEmail).toList();
      // =========================================================================
      // URUTKAN TERBALIK BERDASARKAN ID (TERBARU DI ATAS).
      // =========================================================================
      list.sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));
      return list;
    }

    final db = await instance.database;
    return await db.query(
      'bookings',
      where: 'user_email = ?',
      whereArgs: [userEmail],
      orderBy: 'id DESC',
    );
  }

  // =========================================================================
  // MEMPERBARUI INFORMASI BOOKING TERTENTU BERDASARKAN ID-NYA.
  // =========================================================================
  Future<int> updateBooking(int id, Map<String, dynamic> booking) async {
    if (kIsWeb) {
      await _initWebDB();
      final index = _webBookings!.indexWhere((b) => b['id'] == id);
      if (index != -1) {
        final updated = Map<String, dynamic>.from(_webBookings![index]);
        updated.addAll(booking);
        _webBookings![index] = updated;
        await _saveWebBookings();
        return 1;
      }
      return 0;
    }

    final db = await instance.database;
    return await db.update(
      'bookings',
      booking,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // =========================================================================
  // MENGHAPUS DATA BOOKING BERDASARKAN ID-NYA.
  // =========================================================================
  Future<int> deleteBooking(int id) async {
    if (kIsWeb) {
      await _initWebDB();
      final index = _webBookings!.indexWhere((b) => b['id'] == id);
      if (index != -1) {
        _webBookings!.removeAt(index);
        await _saveWebBookings();
        return 1;
      }
      return 0;
    }

    final db = await instance.database;
    return await db.delete(
      'bookings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
