import 'package:call_log_app/model/offline_form.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;
  static const int _version = 1;
  static const String _formTable = 'form';

  static const String _formQuery =
      'CREATE TABLE $_formTable(id INTEGER PRIMARY KEY AUTOINCREMENT, bankId TEXT, serviceId TEXT, firstName TEXT, middleName TEXT, lastName TEXT, motherName TEXT, spouseName TEXT, fatherName TEXT, email TEXT, mobile TEXT, gender TEXT, qualification TEXT, accountHolder TEXT, currentAddress TEXT, landmark TEXT, city TEXT, pincode TEXT, house TEXT, officeName TEXT, officeEmail TEXT, officeAddress TEXT, officeLandmark TEXT, officePinCode TEXT, officeDesignation TEXT, surrogate TEXT, cardLimit TEXT, netSalary TEXT, panCard TEXT, aadharNo TEXT, adharFrontImage TEXT, adharBackImage TEXT, panCardImage TEXT)';

  static Future<void> initializeDb() async {
    if (_database != null) {
      return;
    }
    try {
      String path = '${await getDatabasesPath()}credlawn.db';
      _database =
          await openDatabase(path, version: _version, onCreate: (db, ver) {
        _createTables(db, ver);
      });
    } catch (e) {
      print(e);
    }
  }

  static Future _createTables(Database db, int version) async {
    await db.execute(_formQuery);
  }

  static Future<int> insertCart(OfflineForm form) async {
    return await _database!.insert(_formTable, form.toJson());
  }

  static Future<List<OfflineForm>> getForms() async {
    List<Map<String, dynamic>> cartMap = await _database!
        .query(_formTable);
    return cartMap.map((e) => OfflineForm.fromJson(e)).toList();
  }
  static Future<int> deleteFormById(int id) async {
    return await _database!
        .delete(_formTable, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updateForm(OfflineForm? form) async {
    return await _database!.update(
      _formTable,
      form!.toJson(),
      where: 'id = ?',
      whereArgs: [form.id],
    );
  }
}
