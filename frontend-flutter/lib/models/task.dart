class Task {
  final int taskId;
  final String taskName;
  final int userId;
  final String status;
  final String priority;
  final String? dueDate;
  final String? reminderAt;

  Task({
    required this.taskId,
    required this.taskName,
    required this.userId,
    required this.status,
    required this.priority,
    this.dueDate,
    this.reminderAt,
  });

  factory Task.fromJson(Map<String, dynamic> j) => Task(
        taskId: j['task_id'],
        taskName: j['task_name'],
        userId: j['user_id'],
        status: j['status'],
        priority: j['priority'],
        dueDate: j['due_date'],
        reminderAt: j['reminder_at'],
      );
}

class User {
  final int id;
  final String username;

  User({required this.id, required this.username});

  factory User.fromJson(Map<String, dynamic> j) =>
      User(id: j['id'], username: j['username']);
}
