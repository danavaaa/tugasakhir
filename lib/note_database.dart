import 'package:notes/note.dart'; //create
import 'package:supabase_flutter/supabase_flutter.dart'; //create

class NoteDatabase {
  // Database -> notes
  final database = Supabase.instance.client.from('notes');

  // create
  Future createNote(Note newNote) async {
    await database.insert(newNote.toMap());
  }

  // read
  final stream = Supabase.instance.client
      .from('notes')
      .stream(primaryKey: ['id'])
      .map((data) => data.map((noteMap) => Note.fromMap(noteMap)).toList());

  // update
  Future<void> updateNote(Note note) async {
    await Supabase.instance.client
        .from('notes')
        .update(note.toMap())
        .eq('id', note.id!);
  }

  //delete
  Future deleteNote(Note note) async {
    await database.delete().eq('id', note.id!);
  }

  // update note status
  Future<void> updateNoteStatus(Note note, bool isDone) async {
    await Supabase.instance.client
        .from('notes')
        .update({'is_done': isDone})
        .eq('id', note.id!);
  }
}
