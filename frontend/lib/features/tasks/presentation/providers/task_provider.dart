import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/task_model.dart';

final taskListProvider = StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  return TaskListNotifier();
});

class TaskListNotifier extends StateNotifier<List<Task>> {
  TaskListNotifier() : super([]) {
    _loadInitialTasks();
  }

  void _loadInitialTasks() {
    // Start empty by default to provide clean state for Guest and fresh accounts
    state = [];
    checkOverdueTasks();
  }

  void checkOverdueTasks() {
    final now = DateTime.now();
    state = state.map((task) {
      if ((task.status == TaskStatus.pending || task.status == TaskStatus.inProgress) &&
          task.dueDate.isBefore(now)) {
        return task.copyWith(status: TaskStatus.overdue);
      }
      return task;
    }).toList();
  }

  void addTask(Task task) {
    state = [...state, task];
    checkOverdueTasks();
  }

  void toggleTaskComplete(String id) {
    state = state.map((task) {
      if (task.id == id) {
        if (task.status == TaskStatus.completed) {
          return task.copyWith(
            status: TaskStatus.pending,
            completedAt: null,
          );
        } else {
          return task.copyWith(
            status: TaskStatus.completed,
            completedAt: DateTime.now(),
          );
        }
      }
      return task;
    }).toList();
    checkOverdueTasks();
  }

  void updateTaskStatus(String id, TaskStatus status) {
    state = state.map((task) {
      if (task.id == id) {
        return task.copyWith(
          status: status,
          completedAt: status == TaskStatus.completed ? DateTime.now() : null,
        );
      }
      return task;
    }).toList();
    checkOverdueTasks();
  }

  void rescheduleTask(String id, DateTime newDueDate) {
    state = state.map((task) {
      if (task.id == id) {
        final now = DateTime.now();
        final newStatus = newDueDate.isBefore(now) ? TaskStatus.overdue : TaskStatus.pending;
        return task.copyWith(
          dueDate: newDueDate,
          status: newStatus,
        );
      }
      return task;
    }).toList();
  }

  void deleteTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }

  bool completeTaskByName(String name) {
    bool found = false;
    state = state.map((task) {
      if (task.title.toLowerCase().contains(name.toLowerCase())) {
        found = true;
        return task.copyWith(
          status: TaskStatus.completed,
          completedAt: DateTime.now(),
        );
      }
      return task;
    }).toList();
    return found;
  }
}
