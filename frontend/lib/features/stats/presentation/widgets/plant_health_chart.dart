import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PlantHealthChart extends StatelessWidget {
  const PlantHealthChart({super.key});

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
          IntrinsicHeight(
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Plant Health Trends', style: AppTextStyles.labelMd),
                      Text(
                        '30-day index based on scan data',
                        style: AppTextStyles.bodySm,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list, size: 16),
                  label: Text('Filter', style: AppTextStyles.labelSm),
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ChartBar(value: 0.40, label: 'W1', index: 65),
                ChartBar(value: 0.55, label: 'W2', index: null),
                ChartBar(value: 0.75, label: 'W3', index: null),
                ChartBar(value: 0.85, label: 'W4', index: null),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChartBar extends StatelessWidget {
  final double value;
  final String label;
  final int? index;

  const ChartBar({
    super.key,
    required this.value,
    required this.label,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 24,
              height: (120 - 20) * value,
              decoration: BoxDecoration(
                color: value > 0.6
                    ? AppColors.primary
                    : AppColors.primaryFixedDim,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.labelSm),
          ],
        ),
      ),
    );
  }
}
