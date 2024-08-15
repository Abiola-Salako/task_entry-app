// Enum for task priority
enum Priority { High, Medium, Low }

// Task class with basic properties
class Task {
  final String title;
  final String description;
  final DateTime dueDate;
  final Priority priority;
  bool isCompleted = false;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
  });
}
// TimedTask subclass, future time-related functionalities can be added here
class TimedTask extends Task {
  TimedTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required Priority priority,
  }) : super(title: title, description: description, dueDate: dueDate, priority: priority);
}

// TaskNotifier mixin to log task completion
mixin TaskNotifier {
  void logCompletion(Task task) {
    print('Task "${task.title}" completed.');
  }
}
