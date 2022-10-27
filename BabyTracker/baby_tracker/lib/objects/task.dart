class Task {
  int? id;
  String? taskText;
  bool isDone;

  Task({
    required this.id,
    required this.taskText,
    this.isDone = false,
  });

  static List<Task> todoList() {
    return [];
  }
}
