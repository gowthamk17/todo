class Todo {
  String? id;
  String? todoText;
  bool isDone;

  Todo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<Todo> todoList() {
    return [
      Todo(id: '1', todoText: "Morning Routine"),
      Todo(id: '2', todoText: "Book Reding"),
      Todo(id: '3', todoText: "Running", isDone: true),
      Todo(id: '4', todoText: "LeetCode Problem solve"),
      Todo(id: '5', todoText: "Meditation", isDone: true),
      Todo(id: '6', todoText: "A Chess game"),
    ];
  }

}