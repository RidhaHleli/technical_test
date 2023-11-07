class Note {
  int? id;
  String title;
  String description;
  DateTime creationDate;
  DateTime dueDate;
  String? imagePath;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.creationDate,
    required this.dueDate,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'creationDate': creationDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      creationDate: DateTime.parse(map['creationDate']),
      dueDate: DateTime.parse(map['dueDate']),
      imagePath: map['imagePath'],
    );
  }
}
