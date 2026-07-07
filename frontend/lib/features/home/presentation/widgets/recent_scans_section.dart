import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/scan/domain/models/chat_message.dart';
import '../../../../features/scan/presentation/screens/scan_chat_screen.dart';
import '../../data/models/mock_home_data.dart';

class RecentScansSection extends StatelessWidget {
  const RecentScansSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Scans', style: AppTextStyles.headlineMd),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              ScanItem(
                icon: Icons.eco,
                iconBg: AppColors.surfaceContainer,
                iconColor: AppColors.primary,
                title: 'Wheat A-12',
                subtitle: 'Healthy • Today, 08:30 AM',
                onTap: () => _openChat(
                  context,
                  title: 'Wheat A-12',
                  subtitle: 'Healthy • Today, 08:30 AM',
                  icon: Icons.eco,
                  iconBg: AppColors.surfaceContainer,
                  iconColor: AppColors.primary,
                  messages: mockMessagesWheat,
                ),
              ),
              _divider(),
              ScanItem(
                icon: Icons.pest_control,
                iconBg: AppColors.errorContainer,
                iconColor: AppColors.error,
                title: 'Corn B-04',
                subtitle: 'Aphid Alert • Yesterday, 14:15',
                onTap: () => _openChat(
                  context,
                  title: 'Corn B-04',
                  subtitle: 'Aphid Alert • Yesterday, 14:15',
                  icon: Icons.pest_control,
                  iconBg: AppColors.errorContainer,
                  iconColor: AppColors.error,
                  messages: mockMessagesCorn,
                ),
              ),
              _divider(),
              ScanItem(
                icon: Icons.storm,
                iconBg: AppColors.surfaceContainer,
                iconColor: AppColors.primary,
                title: 'Soy C-01',
                subtitle: 'Optimal Moisture • 2 days ago',
                onTap: () => _openChat(
                  context,
                  title: 'Soy C-01',
                  subtitle: 'Optimal Moisture • 2 days ago',
                  icon: Icons.storm,
                  iconBg: AppColors.surfaceContainer,
                  iconColor: AppColors.primary,
                  messages: mockMessagesSoy,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openChat(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required List<ChatMessage> messages,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScanChatScreen(
          title: title,
          subtitle: subtitle,
          icon: icon,
          iconBg: iconBg,
          iconColor: iconColor,
          messages: messages,
        ),
      ),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, color: AppColors.outlineVariant);
}

class ScanItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const ScanItem({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(12),
        bottom: Radius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.labelMd),
                  Text(subtitle, style: AppTextStyles.bodySm),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
