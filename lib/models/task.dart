class Task {
  int? id;
  String title;
  String description;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  Task.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        isCompleted = map['isCompleted'] == 1;
}