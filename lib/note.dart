class Note {
  int? id;
  String content;
  bool isDone;

  Note({this.id, required this.content, this.isDone = false});

  /*

  e.g. map <---> note

  {
    'id': 1,
    'content': 'hello'
  }

Note(
  'id': 1,
  'content': 'hello'
  )

  */

  //map -> note
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int,
      content: map['content'] as String,
      isDone: map['is_done'] == true,
    );
  }

  // note -> map
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'content': content, 'is_done': isDone};
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
