import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/weather_card.dart';
import '../widgets/recent_scans_section.dart';
import '../widgets/recommended_actions_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return ListView(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 80 + bottomInset),
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 64,
                child: Row(
                  children: [
                    const Icon(
                      Icons.agriculture,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'KrishiOS',
                      style: AppTextStyles.headlineMd.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const WeatherCard(),
        const SizedBox(height: 24),
        const RecentScansSection(),
        const SizedBox(height: 24),
        const RecommendedActionsSection(),
      ],
    );
  }
}
