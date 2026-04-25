class Todo {
  final int? id;
  final String title;
  final String description;
  final String createdAt;
  final bool isDone;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.isDone = false,
  });

  // Mengonversi Todo menjadi Map untuk disimpan ke database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'isDone': isDone ? 1 : 0, // SQLite menyimpan boolean sebagai integer
    };
  }

  // Mengonversi Map dari database menjadi objek Todo
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: map['createdAt'],
      isDone: map['isDone'] == 1,
    );
  }
}
