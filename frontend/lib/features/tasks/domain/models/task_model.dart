enum TaskPriority { low, medium, high }

enum TaskStatus { pending, inProgress, completed, overdue }

enum TaskCategory { irrigation, fertilizer, pesticide, inspect, harvest, custom }

class Task {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final int estimatedDurationMinutes;
  final TaskStatus status;
  final TaskCategory category;
  final DateTime dueDate;
  final DateTime? completedAt;
  final DateTime? reminderTime;
  final bool isRecurrent;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.estimatedDurationMinutes,
    required this.status,
    required this.category,
    required this.dueDate,
    this.completedAt,
    this.reminderTime,
    this.isRecurrent = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    int? estimatedDurationMinutes,
    TaskStatus? status,
    TaskCategory? category,
    DateTime? dueDate,
    DateTime? completedAt,
    DateTime? reminderTime,
    bool? isRecurrent,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      estimatedDurationMinutes: estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      status: status ?? this.status,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      reminderTime: reminderTime ?? this.reminderTime,
      isRecurrent: isRecurrent ?? this.isRecurrent,
    );
  }
}
