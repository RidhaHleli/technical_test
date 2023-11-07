import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../helpers/data_base_helper.dart';
import '../models/note_model.dart';

class NotesProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> fetchNotes() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> notesMap = await db.query('notes');
    _notes = notesMap.map((noteMap) => Note.fromMap(noteMap)).toList();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    final db = await _databaseHelper.database;
    final id = await db.insert('notes', note.toMap());
    note.id = id;
    _notes.add(note);
    notifyListeners();
  }

  void editNote(int index, Note note) {
    _notes[index] = note;
    notifyListeners();
  }

  Future<void> _deleteNoteFromDatabase(int id) async {
    final db = await _databaseHelper.database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  void deleteNote(Note note) {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes.removeAt(index);

      _deleteNoteFromDatabase(note.id!);

      notifyListeners();
    }
  }
}
