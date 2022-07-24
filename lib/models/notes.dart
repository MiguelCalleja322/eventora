class Notes {
  final List<Note>? notes;

  Notes({this.notes});

  factory Notes.fromJson(List<dynamic> json) {
    return Notes(notes: json.map((note) => Note.fromJson(note)).toList());
  }
}

class Note {
  int id;
  String title;
  String description;

  Note({required this.id, required this.title, required this.description});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }
}
