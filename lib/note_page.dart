import 'package:flutter/material.dart';
import 'package:notes/note.dart';
import 'package:notes/note_database.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  //notes db
  final notesDatabase = NoteDatabase();

  //text controller
  final noteControllerr = TextEditingController();

  // jika user ingin menambahkan catatan baru
  void addNewNote() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("New Note"),
            content: TextField(controller: noteControllerr),
            actions: [
              // cancel button
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  noteControllerr.clear();
                },
                child: const Text("Cancel"),
              ),

              // save button
              TextButton(
                onPressed: () {
                  //buat note baru
                  final newNote = Note(content: noteControllerr.text);
                  // save database
                  notesDatabase.createNote(newNote);

                  Navigator.pop(context);
                  noteControllerr.clear();
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  // jika user ingin mengupdate catatan
  void updateNote(Note note) {
    // pre-fill text controller with existing note
    noteControllerr.text = note.content;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Update Note"),
            content: TextField(controller: noteControllerr),
            actions: [
              // cancel button
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  noteControllerr.clear();
                },
                child: const Text("Cancel"),
              ),

              // save button
              TextButton(
                onPressed: () {
                  // update isi catatan
                  note.content = noteControllerr.text;
                  // simpan perubahan di database
                  notesDatabase.updateNote(note);

                  Navigator.pop(context);
                  noteControllerr.clear();
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  // jika user ingin menghapus catatan
  void deleteNote(Note note) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Note?"),
            actions: [
              // cancel button
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  noteControllerr.clear();
                },
                child: const Text("Cancel"),
              ),

              // save button
              TextButton(
                onPressed: () {
                  // save in db
                  notesDatabase.deleteNote(note);

                  Navigator.pop(context);
                  noteControllerr.clear();
                },
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }

  //Desain tampilan halaman

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: AppBar(
        title: const Text(
          "Keep Notes",
          style: TextStyle(
            fontWeight: FontWeight.bold, // Tebal
            fontSize: 26, // Ukuran font
            color: Color.fromARGB(255, 0, 0, 0), // Warna tulisan
            letterSpacing: 2, // Jarak antar huruf
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 144, 188, 223),
      // Button
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        child: const Icon(Icons.add),
      ),

      // Body -> Stream Builder
      body: StreamBuilder(
        // Listens to this stream..
        stream: notesDatabase.stream,

        // to build our UI..
        builder: (context, snapshot) {
          //loading
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          //loaded!
          final notes = snapshot.data!;

          // list of notes UI
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              //get each note
              final note = notes[index];

              //list tile UI
              return ListTile(
                leading: Checkbox(
                  value: note.isDone,
                  onChanged: (value) {
                    setState(() {
                      note.isDone = value!;
                    });
                    //update the note in the database
                    notesDatabase.updateNoteStatus(note, value!);
                  },
                ),
                title: Text(
                  note.content,
                  style: TextStyle(
                    decoration: note.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      // update button
                      IconButton(
                        onPressed: () => updateNote(note),
                        icon: const Icon(Icons.edit),
                      ),

                      //delete button
                      IconButton(
                        onPressed: () => deleteNote(note),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
