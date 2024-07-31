


import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initializeDb();
    return _database!;
  }

  Future<Database> initializeDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'mydb.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: onCreate,
    );
  }

  Future onCreate(Database db, int version) async {
    await db.execute(
        '''
      CREATE TABLE mytable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT ,
        description TEXT ,
        date TEXT 
      )
      '''
    );
  }

  Future<int> insertNote(String title, String description) async {
    Database db = await database;
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return await db.insert('mytable', {
      'title': title,
      'description': description,
      'date': formattedDate,
    });
  }

  Future<int> updateNotes(String title,  String description, int id) async{
    Database db = await database ;
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return await db.update('mytable', {
      'title': title,
      'description': description,
      'date': formattedDate,

    },where: 'id = ?' ,
      whereArgs: [id]
    );

    
    
    
  }
  Future<int> deleteNote(int id)  async{

    Database db = await database;
   return await db.delete('mytable', where: 'id = ? ',
   whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    Database db = await database;
    return await db.query('mytable', orderBy: 'date DESC');
  }
}
