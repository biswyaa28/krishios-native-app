import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/core/providers/theme_provider.dart';
import 'package:krishios/features/tasks/domain/models/task_model.dart';
import 'package:krishios/features/tasks/presentation/providers/task_provider.dart';
import 'package:krishios/features/scan/presentation/providers/scan_provider.dart';
import 'package:krishios/shared/models/scan_result.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  String _currentView = 'Month'; // Month, Week, Day, Agenda

  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider); // Sync dark mode
    final tasks = ref.watch(taskListProvider);
    final scans = ref.watch(scanHistoryProvider);

    final selectedDayEvents = _getEventsForDate(_selectedDate, tasks, scans);

    return Scaffold(
      appBar: AppBar(
        title: Text('Farm Calendar', style: AppTextStyles.headlineLgMobile.copyWith(color: AppColors.primary)),
        actions: [
          DropdownButton<String>(
            value: _currentView,
            underline: const SizedBox(),
            icon: Icon(Icons.tune, color: AppColors.primary),
            items: ['Month', 'Week', 'Day', 'Agenda'].map((String view) {
              return DropdownMenuItem<String>(
                value: view,
                child: Text(view),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() => _currentView = val);
              }
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          if (_currentView == 'Month') _buildMonthCalendar(tasks, scans),
          if (_currentView == 'Week') _buildWeekCalendar(tasks, scans),
          if (_currentView == 'Day' || _currentView == 'Agenda') _buildDayHeader(),
          const Divider(height: 1),
          Expanded(
            child: _buildAgendaList(selectedDayEvents),
          ),
        ],
      ),
    );
  }

  Widget _buildDayHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surfaceContainerLow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => setState(() => _selectedDate = _selectedDate.subtract(const Duration(days: 1))),
          ),
          Text(
            DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate),
            style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => setState(() => _selectedDate = _selectedDate.add(const Duration(days: 1))),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthCalendar(List<Task> tasks, List<ScanResult> scans) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final daysInMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
    final leadingDays = firstDayOfMonth.weekday % 7; // Sunday start index adjustment

    return Column(
      children: [
        // Month Selector Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => setState(() => _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1)),
              ),
              Text(
                DateFormat('MMMM yyyy').format(_selectedDate),
                style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => setState(() => _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1)),
              ),
            ],
          ),
        ),
        // Days of week row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((d) {
              return SizedBox(
                width: 40,
                child: Text(d, textAlign: TextAlign.center, style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.bold)),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        // Calendar Grid
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 240,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1.1,
            ),
            itemCount: leadingDays + daysInMonth,
            itemBuilder: (context, index) {
              if (index < leadingDays) return const SizedBox.shrink();
              final day = index - leadingDays + 1;
              final date = DateTime(_selectedDate.year, _selectedDate.month, day);
              final isSelected = DateUtils.isSameDay(date, _selectedDate);
              final isToday = DateUtils.isSameDay(date, now);
              final events = _getEventsForDate(date, tasks, scans);

              return GestureDetector(
                onTap: () => setState(() => _selectedDate = date),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : isToday
                            ? AppColors.primaryContainer.withValues(alpha: 0.2)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday ? Border.all(color: AppColors.primary, width: 1.5) : null,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? AppColors.onPrimary
                              : isToday
                                  ? AppColors.primary
                                  : AppColors.onSurface,
                        ),
                      ),
                      if (events.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: events.take(3).map((e) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1.0),
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: e.color,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeekCalendar(List<Task> tasks, List<ScanResult> scans) {
    // Generate 7 days centered on the selected week
    final now = DateTime.now();
    final startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday % 7));

    return Column(
      children: [
        _buildDayHeader(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              final date = startOfWeek.add(Duration(days: index));
              final isSelected = DateUtils.isSameDay(date, _selectedDate);
              final isToday = DateUtils.isSameDay(date, now);
              final dayName = DateFormat('E').format(date);
              final dayNum = date.day;
              final events = _getEventsForDate(date, tasks, scans);

              return GestureDetector(
                onTap: () => setState(() => _selectedDate = date),
                child: Container(
                  width: 44,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : isToday
                            ? AppColors.primaryContainer.withValues(alpha: 0.2)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: isToday ? Border.all(color: AppColors.primary, width: 1) : null,
                  ),
                  child: Column(
                    children: [
                      Text(dayName, style: TextStyle(fontSize: 12, color: isSelected ? AppColors.onPrimary : AppColors.outline)),
                      const SizedBox(height: 4),
                      Text(
                        '$dayNum',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                        ),
                      ),
                      if (events.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(color: isSelected ? AppColors.onPrimary : AppColors.primary, shape: BoxShape.circle),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildAgendaList(List<_CalendarEvent> events) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note, size: 64, color: AppColors.outlineVariant),
            const SizedBox(height: 12),
            Text('No events scheduled for today', style: AppTextStyles.labelMd.copyWith(color: AppColors.outline)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: event.color.withValues(alpha: 0.15),
              child: Icon(event.icon, color: event.color),
            ),
            title: Text(event.title, style: AppTextStyles.labelMd),
            subtitle: Text(event.timeString, style: AppTextStyles.bodySm.copyWith(color: AppColors.outline)),
            trailing: Text(event.type.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: event.color)),
          ),
        );
      },
    );
  }

  List<_CalendarEvent> _getEventsForDate(DateTime date, List<Task> tasks, List<ScanResult> scans) {
    final events = <_CalendarEvent>[];

    // Filter Tasks
    for (final task in tasks) {
      if (DateUtils.isSameDay(task.dueDate, date)) {
        Color pColor = Colors.green;
        if (task.priority == TaskPriority.high) pColor = Colors.red;
        if (task.priority == TaskPriority.medium) pColor = Colors.orange;

        events.add(_CalendarEvent(
          title: task.title,
          timeString: DateFormat('hh:mm a').format(task.dueDate),
          icon: task.category == TaskCategory.irrigation
              ? Icons.water_drop
              : task.category == TaskCategory.pesticide
                  ? Icons.science
                  : Icons.assignment,
          color: pColor,
          type: 'Task',
        ));
      }
    }

    // Filter Crop Scans
    for (final scan in scans) {
      if (DateUtils.isSameDay(scan.scannedAt, date)) {
        events.add(_CalendarEvent(
          title: '${scan.cropName} Diagnostic: ${scan.diagnosis}',
          timeString: DateFormat('hh:mm a').format(scan.scannedAt),
          icon: Icons.camera_alt,
          color: Colors.blue,
          type: 'Scan',
        ));
      }
    }

    return events;
  }
}

class _CalendarEvent {
  final String title;
  final String timeString;
  final IconData icon;
  final Color color;
  final String type;

  _CalendarEvent({
    required this.title,
    required this.timeString,
    required this.icon,
    required this.color,
    required this.type,
  });
}
