import 'package:login_screen/note1/model/note.dart';
import 'package:sqflite/sqflite.dart';

class NoteDatabase {
  static Database? database;

  static Future<void> init() async {
    // open the database
    await openDatabase(
      'notes.db',
      version: 1,
      onCreate: (Database db, int version) async {
        print('Database created');
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE Notes (id TEXT, userId TEXT, title TEXT, content TEXT)');
        print('Table created');
      },
      onOpen: (db) {
        print('Database opened');
        database = db;
      },
    );
  }

  static void insertNotes(Note note) async {
    // Insert some records in a transaction
    await database!.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO Notes(id, userId, title, content) VALUES("${note.id}", "${note.userId}", "${note.title}", "${note.content}")');
      print('inserted1: $id');
    });
  }

  static Future<List<Note>> getNotes() async {
    List<Map> list = await database!.rawQuery('SELECT * FROM Notes');
    return list.map((e) => Note.fromMap(e)).toList();
  }

  static void deleteNote(String id) async {
    await database!.rawDelete('DELETE FROM Notes WHERE id = ?', ['$id']);
  }

  static void updateNote(Note note) async {
    await database!.rawUpdate(
        'UPDATE Notes SET title = ?, content = ? WHERE id = ?',
        ['${note.title}', '${note.content}', '${note.id}']);
  }
}
