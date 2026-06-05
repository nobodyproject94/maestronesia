import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Web Simulation Fallback lists
  static List<Map<String, dynamic>>? _webUsers;
  static List<Map<String, dynamic>>? _webBookings;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError('sqflite does not support Web');
    }
    if (_database != null) return _database!;
    _database = await _initDB('maestronesia.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.execute('ALTER TABLE bookings ADD COLUMN notes TEXT');
      } catch (e) {
        // column might already exist
      }
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT,
        name TEXT,
        role TEXT
      )
    ''');

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

    // Pre-populate some dummy bookings to make the history screen look alive
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

  // Helper methods to manage web simulation state in SharedPreferences
  Future<void> _initWebDB() async {
    if (_webUsers != null) return;
    final prefs = await SharedPreferences.getInstance();
    
    final usersStr = prefs.getString('web_users');
    if (usersStr != null) {
      _webUsers = List<Map<String, dynamic>>.from(
        (jsonDecode(usersStr) as List).map((x) => Map<String, dynamic>.from(x as Map))
      );
    } else {
      _webUsers = [];
    }

    final bookingsStr = prefs.getString('web_bookings');
    if (bookingsStr != null) {
      _webBookings = List<Map<String, dynamic>>.from(
        (jsonDecode(bookingsStr) as List).map((x) => Map<String, dynamic>.from(x as Map))
      );
    } else {
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

  Future<void> _saveWebUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('web_users', jsonEncode(_webUsers));
  }

  Future<void> _saveWebBookings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('web_bookings', jsonEncode(_webBookings));
  }

  Future<Map<String, dynamic>?> registerUser(Map<String, dynamic> user) async {
    if (kIsWeb) {
      await _initWebDB();
      final email = user['email'];
      final exists = _webUsers!.any((u) => u['email'] == email);
      if (exists) return null;
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

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    if (kIsWeb) {
      await _initWebDB();
      final matches = _webUsers!.where(
        (u) => u['email'] == email && u['password'] == password,
      );
      if (matches.isNotEmpty) {
        return matches.first;
      }
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
    // Default mock user
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

  Future<List<Map<String, dynamic>>> getBookings(String userEmail) async {
    if (kIsWeb) {
      await _initWebDB();
      final list = _webBookings!.where((b) => b['user_email'] == userEmail).toList();
      // Sort reverse by ID
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
