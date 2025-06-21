import 'package:flutter/material.dart';
import 'package:notes/note.dart';
import 'package:notes/note_database.dart';
import 'widgets/task_category_card.dart';

class NotePage extends StatefulWidget {
  // ignore: use_super_parameters
  const NotePage({Key? key}) : super(key: key);

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
        backgroundColor: const Color.fromARGB(255, 232, 220, 229),
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
      backgroundColor: const Color.fromARGB(
        255,
        232,
        220,
        229,
      ), // warna latar belakang
      // Button
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        child: const Icon(Icons.add),
      ),

      // Body -> Stream Builder
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
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

                // Urutan List
                notes.sort((a, b) {
                  if (a.isDone == b.isDone) return 0;
                  return a.isDone ? 1 : -1;
                });

                // jika tidak ada catatan
                if (notes.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Notes Yet",
                      style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 220, 205, 213),
                      ),
                    ),
                  );
                }

                // hitung jumlah selesai dan total catatan
                final completed = notes.where((note) => !note.isDone).length;
                final total = notes.length;

                return Column(
                  children: [
                    // card UI
                    TaskCategoryCard(
                      title: "To Do List",
                      completed: completed,
                      total: total,
                    ),
                    const SizedBox(height: 16), // jarak antar card dan list
                    // list of notes UI
                    Expanded(
                      child: ListView.builder(
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
                                decoration:
                                    note.isDone
                                        ? TextDecoration.lineThrough
                                        : null,
                              ),
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  // update button
                                  IconButton(
                                    onPressed:
                                        note.isDone
                                            ? null
                                            : () => updateNote(note),
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
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
