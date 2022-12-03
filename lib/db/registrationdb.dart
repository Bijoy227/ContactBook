import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Table and columns name
final String registrationTable = 'registrationTable';
final String idColumn = 'idColumn';
final String mailColumn = 'mailColumn';
final String passwordColumn = 'passwordColumn';

class RegistrationHelper {
  static final RegistrationHelper _instance = RegistrationHelper.internal();
  factory RegistrationHelper() => _instance;
  RegistrationHelper.internal();
  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  // Creating table
  Future<Database> initDb() async {
    print('Init DB Executed!');
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'registrationTable.db');
    return await openDatabase(path, version: 1,
        onCreate: (db, newerVersion) async {
      await db.execute('CREATE TABLE $registrationTable('
          '$idColumn INTEGER PRIMARY KEY,'
          '$mailColumn TEXT,'
          '$passwordColumn TEXT)');
    });
  }

  // Saving new user
  Future<User> save(User user) async {
    var dbClient = await db;
    user.id = await dbClient.insert(registrationTable, user.toMap());
    return user;
  }

  // Checking if any user existed with particular email
  Future<bool> isRegistered(String email) async {
    var dbContact = await db;
    List<Map> maps = await dbContact.query(registrationTable,
        columns: [mailColumn], where: '$mailColumn = ?', whereArgs: [email]);

    if (maps.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  //  For Log In Purpose. Checking if password and email are valid.
  Future<bool> isValidUser(String email, String password) async {
    var dbContact = await db;
    List<Map> maps = await dbContact.query(registrationTable,
        columns: [passwordColumn],
        where: '$mailColumn = ? and $passwordColumn = ?',
        whereArgs: [email, password]);

    if (maps.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  // Closing database
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}

// User Model
class User {
  int id;
  String email;
  String password;
  User(this.id, this.email, this.password);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'email': email,
      'password': password,
    };
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    email = map['email'];
    password = map['password'];
  }
}
