import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../tasks/domain/models/task_model.dart';
import '../../../tasks/presentation/providers/task_provider.dart';
import '../../../scan/presentation/screens/chat_screen.dart';
import '../screens/action_detail_screen.dart';

class RecommendationItem {
  final String id;
  final String title;
  final String explanation;
  final TaskPriority priority;
  final IconData icon;
  final Color iconColor;

  RecommendationItem({
    required this.id,
    required this.title,
    required this.explanation,
    required this.priority,
    required this.icon,
    required this.iconColor,
  });
}

class RecommendedActionsSection extends ConsumerStatefulWidget {
  const RecommendedActionsSection({super.key});

  @override
  ConsumerState<RecommendedActionsSection> createState() => _RecommendedActionsSectionState();
}

class _RecommendedActionsSectionState extends ConsumerState<RecommendedActionsSection> {
  late List<RecommendationItem> _recommendations;

  @override
  void initState() {
    super.initState();
    _recommendations = [
      RecommendationItem(
        id: 'rec_delay_watering',
        title: 'Delay watering in South Field',
        explanation: 'High soil moisture (82%) detected from recent rainfall. Delaying watering by 48 hours will prevent root rot.',
        priority: TaskPriority.medium,
        icon: Icons.water_drop,
        iconColor: Colors.blue,
      ),
      RecommendationItem(
        id: 'rec_spray_fungicide',
        title: 'Apply fungicide in Sector B',
        explanation: 'Fungal spread risk is high (85% humidity forecast). Preventive spraying is highly recommended within 24 hours.',
        priority: TaskPriority.high,
        icon: Icons.science,
        iconColor: Colors.red,
      ),
      RecommendationItem(
        id: 'rec_cotton_harvest',
        title: 'Harvest ready cotton crops',
        explanation: 'Bolls are fully opened in cotton plants of Field C. Harvesting now prevents fiber damage from upcoming rain.',
        priority: TaskPriority.medium,
        icon: Icons.eco,
        iconColor: Colors.orange,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider); // Sync theme toggles

    if (_recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Recommendations',
          style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: 12),
        ..._recommendations.map((rec) => _buildInteractiveCard(rec)),
      ],
    );
  }

  Widget _buildInteractiveCard(RecommendationItem rec) {
    String priorityText = rec.priority.name.toUpperCase();
    Color priorityColor = rec.priority == TaskPriority.high ? Colors.red : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Priority Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: rec.iconColor.withValues(alpha: 0.15),
                  child: Icon(rec.icon, color: rec.iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rec.title, style: AppTextStyles.headlineMd.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(color: priorityColor, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Priority: $priorityText',
                            style: TextStyle(fontSize: 11, color: priorityColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () {
                    setState(() {
                      _recommendations.removeWhere((r) => r.id == rec.id);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Explanation
            Text(
              rec.explanation,
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface),
            ),
            const SizedBox(height: 16),
            // Actions Toolbar
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ActionButton(
                  icon: Icons.add_task,
                  label: 'Schedule Task',
                  onPressed: () {
                    final task = Task(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: rec.title,
                      description: rec.explanation,
                      priority: rec.priority,
                      estimatedDurationMinutes: 45,
                      status: TaskStatus.pending,
                      category: rec.icon == Icons.water_drop ? TaskCategory.irrigation : TaskCategory.custom,
                      dueDate: DateTime.now().add(const Duration(days: 1)),
                    );
                    ref.read(taskListProvider.notifier).addTask(task);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Scheduled task: "${rec.title}"')),
                    );
                  },
                ),
                _ActionButton(
                  icon: Icons.calendar_month,
                  label: 'Add to Calendar',
                  onPressed: () {
                    final task = Task(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: rec.title,
                      description: rec.explanation,
                      priority: rec.priority,
                      estimatedDurationMinutes: 45,
                      status: TaskStatus.pending,
                      category: rec.icon == Icons.water_drop ? TaskCategory.irrigation : TaskCategory.custom,
                      dueDate: DateTime.now().add(const Duration(days: 2)),
                    );
                    ref.read(taskListProvider.notifier).addTask(task);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added to Calendar: "${rec.title}"')),
                    );
                  },
                ),
                _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: 'Ask Kavya',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          scanId: rec.id,
                          cropName: 'Tomato',
                          diagnosis: rec.title,
                          initialQuery: 'Tell me more about how to: ${rec.title}',
                        ),
                      ),
                    );
                  },
                ),
                _ActionButton(
                  icon: Icons.info_outline,
                  label: 'Details',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ActionDetailScreen(
                          icon: rec.icon,
                          iconColor: rec.iconColor,
                          label: 'Recommendation',
                          title: rec.title,
                          description: rec.explanation,
                          buttonText: 'Schedule Task',
                          sections: [
                            DetailSection(
                              icon: Icons.info_outline,
                              title: 'AI Explanation',
                              body: rec.explanation,
                            ),
                            DetailSection(
                              icon: Icons.analytics_outlined,
                              title: 'Confidence Matrix',
                              body: 'Based on high predictive microclimate data matching with previous scan timelines.',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                _ActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onPressed: () {
                    Share.share('AI recommendation from KrishiOS: ${rec.title}\n\nExplanation: ${rec.explanation}');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 14, color: AppColors.primary),
      label: Text(label),
      labelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
      backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.1),
      side: BorderSide(color: AppColors.primaryContainer.withValues(alpha: 0.3)),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      onPressed: onPressed,
    );
  }
}
