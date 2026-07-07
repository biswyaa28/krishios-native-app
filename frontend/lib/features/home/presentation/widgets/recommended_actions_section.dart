import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../screens/action_detail_screen.dart';

class RecommendedActionsSection extends StatelessWidget {
  const RecommendedActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recommended Actions', style: AppTextStyles.headlineMd),
        const SizedBox(height: 12),
        ActionCard(
          icon: Icons.water_drop,
          iconColor: AppColors.tertiaryContainer,
          label: 'Irrigation',
          title: 'Delay watering in South Field',
          description:
              'High soil moisture detected. Forecast suggests adequate humidity levels for the next 48 hours.',
          buttonText: 'View Details',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ActionDetailScreen(
                icon: Icons.water_drop,
                iconColor: AppColors.tertiaryContainer,
                label: 'Irrigation',
                title: 'Delay watering in South Field',
                description:
                    'High soil moisture detected. Forecast suggests adequate humidity levels for the next 48 hours.',
                buttonText: 'View Details',
                sections: [
                  DetailSection(
                    icon: Icons.water_drop_outlined,
                    title: 'Soil Moisture Analysis',
                    body:
                        'Current soil moisture in South Field is at 82%, well above the optimal threshold of 60-70%. '
                        'The past 72 hours recorded 18mm of rainfall, saturating the root zone to a depth of 30cm.',
                  ),
                  DetailSection(
                    icon: Icons.wb_cloudy_outlined,
                    title: '48-Hour Forecast',
                    body:
                        'Humidity levels are expected to remain between 75-85% with a 60% chance of scattered showers. '
                        'Daytime temperatures will range from 28-32°C, limiting evaporation loss.',
                  ),
                  DetailSection(
                    icon: Icons.auto_graph,
                    title: 'Recommendation Timeline',
                    body:
                        'Delay irrigation by at least 48 hours. Resume normal schedule once soil moisture drops below 75%. '
                        'Monitor for waterlogging in low-lying areas of the field.',
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ActionCard(
          icon: Icons.science,
          iconColor: AppColors.primary,
          label: 'Fertilizer',
          title: 'Optimal window for Nitrogen',
          description:
              'Current temperatures are ideal for applying Nitrogen-based fertilizer to the Wheat A-12 sector.',
          buttonText: 'Schedule Action',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ActionDetailScreen(
                icon: Icons.science,
                iconColor: AppColors.primary,
                label: 'Fertilizer',
                title: 'Optimal window for Nitrogen',
                description:
                    'Current temperatures are ideal for applying Nitrogen-based fertilizer to the Wheat A-12 sector.',
                buttonText: 'Schedule Action',
                sections: [
                  DetailSection(
                    icon: Icons.thermostat,
                    title: 'Temperature Analysis',
                    body:
                        'Current soil temperature is 26°C, within the optimal range of 20-30°C for Nitrogen uptake. '
                        'Nighttime lows of 22°C will minimize volatilization losses.',
                  ),
                  DetailSection(
                    icon: Icons.science_outlined,
                    title: 'Application Plan',
                    body:
                        'Apply Urea at 120 kg/ha using split application: 60% basal + 40% top dressing at tillering. '
                        'Incorporate into soil within 24 hours of application to prevent ammonia loss.',
                  ),
                  DetailSection(
                    icon: Icons.eco,
                    title: 'Expected Outcome',
                    body:
                        'Timely application is projected to improve tiller count by 15-20% and increase overall yield by 8-12%. '
                        'Optimal uptake window closes in approximately 72 hours based on forecasted weather shift.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback? onPressed;

  const ActionCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.title,
    required this.description,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label.toUpperCase(),
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: AppTextStyles.labelMd),
          const SizedBox(height: 4),
          Text(description, style: AppTextStyles.bodySm),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onPressed,
            child: Text(
              buttonText,
              style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
