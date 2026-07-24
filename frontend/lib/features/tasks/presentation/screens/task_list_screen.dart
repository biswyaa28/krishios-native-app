import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/core/providers/theme_provider.dart';
import '../../domain/models/task_model.dart';
import '../providers/task_provider.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider); // Trigger redraw on theme toggle
    final tasks = ref.watch(taskListProvider);

    final pending = tasks.where((t) => t.status == TaskStatus.pending).toList();
    final inProgress = tasks.where((t) => t.status == TaskStatus.inProgress).toList();
    final completed = tasks.where((t) => t.status == TaskStatus.completed).toList();
    final overdue = tasks.where((t) => t.status == TaskStatus.overdue).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager', style: AppTextStyles.headlineLgMobile.copyWith(color: AppColors.primary)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.outline,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: 'Pending (${pending.length})'),
            Tab(text: 'In Progress (${inProgress.length})'),
            Tab(text: 'Overdue (${overdue.length})'),
            Tab(text: 'Completed (${completed.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _TaskListSection(tasks: pending, status: TaskStatus.pending),
          _TaskListSection(tasks: inProgress, status: TaskStatus.inProgress),
          _TaskListSection(tasks: overdue, status: TaskStatus.overdue),
          _TaskListSection(tasks: completed, status: TaskStatus.completed),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
        onPressed: () => _showAddTaskSheet(context),
      ),
    );
  }

  void _showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const _AddTaskForm(),
        );
      },
    );
  }
}

class _TaskListSection extends ConsumerWidget {
  final List<Task> tasks;
  final TaskStatus status;

  const _TaskListSection({required this.tasks, required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_turned_in_outlined, size: 64, color: AppColors.outlineVariant),
            const SizedBox(height: 16),
            Text(
              'No tasks found',
              style: AppTextStyles.labelMd.copyWith(color: AppColors.outline),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showTaskDetails(context, ref, task),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Checkbox(
                    activeColor: AppColors.primary,
                    value: task.status == TaskStatus.completed,
                    onChanged: (_) {
                      ref.read(taskListProvider.notifier).toggleTaskComplete(task.id);
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: AppTextStyles.labelMd.copyWith(
                            decoration: task.status == TaskStatus.completed ? TextDecoration.lineThrough : null,
                            color: task.status == TaskStatus.overdue ? Colors.red : AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySm.copyWith(color: AppColors.outline),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _CategoryChip(category: task.category),
                            const SizedBox(width: 8),
                            _PriorityChip(priority: task.priority),
                            const SizedBox(width: 8),
                            Icon(Icons.access_time, size: 14, color: AppColors.outline),
                            const SizedBox(width: 4),
                            Text(
                              '${task.estimatedDurationMinutes}m',
                              style: AppTextStyles.bodySm.copyWith(color: AppColors.outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: AppColors.outlineVariant),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showTaskDetails(BuildContext context, WidgetRef ref, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(task.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.description, style: AppTextStyles.bodyMd),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Category:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(task.category.name.toUpperCase()),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Priority:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(task.priority.name.toUpperCase()),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Estimated Duration:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${task.estimatedDurationMinutes} minutes'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Due Date:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(DateFormat('MMM dd, yyyy - hh:mm a').format(task.dueDate)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(task.status.name.toUpperCase()),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(taskListProvider.notifier).deleteTask(task.id);
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
            if (task.status != TaskStatus.completed)
              TextButton(
                onPressed: () {
                  ref.read(taskListProvider.notifier).updateTaskStatus(task.id, TaskStatus.completed);
                  Navigator.pop(context);
                },
                child: const Text('Complete'),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final TaskCategory category;
  const _CategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        category.name.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final TaskPriority priority;
  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color chipColor = Colors.grey;
    if (priority == TaskPriority.high) chipColor = Colors.red;
    if (priority == TaskPriority.medium) chipColor = Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        priority.name.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: chipColor),
      ),
    );
  }
}

class _AddTaskForm extends ConsumerStatefulWidget {
  const _AddTaskForm();

  @override
  ConsumerState<_AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends ConsumerState<_AddTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _durationController = TextEditingController(text: '30');

  TaskPriority _priority = TaskPriority.medium;
  TaskCategory _category = TaskCategory.custom;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Create New Task', style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Task Title', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Title required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<TaskCategory>(
                      initialValue: _category,
                      decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                      items: TaskCategory.values.map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat.name.toUpperCase()));
                      }).toList(),
                      onChanged: (val) => setState(() => _category = val ?? TaskCategory.custom),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<TaskPriority>(
                      initialValue: _priority,
                      decoration: const InputDecoration(labelText: 'Priority', border: OutlineInputBorder()),
                      items: TaskPriority.values.map((pri) {
                        return DropdownMenuItem(value: pri, child: Text(pri.name.toUpperCase()));
                      }).toList(),
                      onChanged: (val) => setState(() => _priority = val ?? TaskPriority.medium),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _durationController,
                      decoration: const InputDecoration(labelText: 'Duration (minutes)', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_month),
                      label: Text(DateFormat('MMM dd').format(_dueDate)),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _dueDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 30)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() => _dueDate = DateTime(picked.year, picked.month, picked.day, _dueDate.hour, _dueDate.minute));
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final task = Task(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: _titleController.text.trim(),
                      description: _descController.text.trim(),
                      priority: _priority,
                      estimatedDurationMinutes: int.tryParse(_durationController.text) ?? 30,
                      status: TaskStatus.pending,
                      category: _category,
                      dueDate: _dueDate,
                    );
                    ref.read(taskListProvider.notifier).addTask(task);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
