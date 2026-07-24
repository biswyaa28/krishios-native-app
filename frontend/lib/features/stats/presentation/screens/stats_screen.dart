import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/scan_result.dart';
import 'package:krishios/shared/presentation/providers/language_provider.dart';
import 'package:krishios/shared/presentation/widgets/krishi_mobile_header.dart';
import 'package:krishios/shared/services/translation_service.dart';
import '../../../scan/presentation/providers/scan_provider.dart';
import '../health_chart.dart';
import '../widgets/lifetime_scans_card.dart';
import '../widgets/yield_efficiency_card.dart';
import '../widgets/stats_recommendations_section.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final scans = ref.watch(scanHistoryProvider);
    final avgHealth = ref.watch(averageHealthProvider);
    final weeklyCount = ref.watch(weeklyScanCountProvider);
    final lifetimeCount = scans.length;
    final activeLang = ref.watch(languageProvider);

    return ListView(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 80 + bottomInset),
      children: [
        KrishiMobileHeader(
          subtitle: TranslationService.translate('crop_health_stats', activeLang),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('Yield & Analytics', style: AppTextStyles.headlineLgMobile),
              const SizedBox(height: 4),
              Text(
                'Overview of farm health and performance metrics.',
                style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: LifetimeScansCard(
                      lifetimeCount: lifetimeCount,
                      weeklyCount: weeklyCount,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: YieldEfficiencyCard(
                      healthScore: avgHealth,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              HealthChart(scans: scans.cast<ScanResult>()),
              const SizedBox(height: 16),
              const StatsRecommendationsSection(),
            ],
          ),
        ),
      ],
    );
  }
}
