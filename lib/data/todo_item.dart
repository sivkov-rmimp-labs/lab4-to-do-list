class TodoItem {
  final int id;

  String title;
  DateTime dueDate;
  String? description;
  bool isDone;

  TodoItem({
    required this.id,
    required this.title,
    required this.dueDate,
    this.description,
    this.isDone = false,
  });
}
