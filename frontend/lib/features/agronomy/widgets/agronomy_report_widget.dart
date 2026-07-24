import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/scan_result.dart';
import '../../../../shared/models/weather.dart';
import '../engine/decision_engine.dart';
import '../models/disease_metadata.dart';
import '../models/agronomy_recommendation.dart';
import '../services/agronomy_service.dart';

class AgronomyReportWidget extends ConsumerStatefulWidget {
  final ScanResult scan;
  final Weather? weather;

  const AgronomyReportWidget({
    super.key,
    required this.scan,
    required this.weather,
  });

  @override
  ConsumerState<AgronomyReportWidget> createState() => _AgronomyReportWidgetState();
}

class _AgronomyReportWidgetState extends ConsumerState<AgronomyReportWidget> with SingleTickerProviderStateMixin {
  late String _preference;
  late String _soilType;
  late String _growthStage;

  final _engine = DecisionEngine();
  DiseaseMetadata? _metadata;
  bool _loading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _preference = 'Organic';
    _soilType = 'Loamy';
    _growthStage = 'Vegetative';
    _tabController = TabController(length: 3, vsync: this);
    _loadKnowledgeBase();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadKnowledgeBase() async {
    final service = ref.read(agronomyServiceProvider);
    await service.loadKnowledgeBase();
    if (mounted) {
      setState(() {
        _metadata = service.lookup(widget.scan.diagnosis);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _metadata == null) {
      return Container(
        height: 180,
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    final recommendation = _engine.process(
      disease: _metadata!,
      confidence: widget.scan.confidence ?? 1.0,
      healthScore: widget.scan.healthScore,
      weather: widget.weather,
      soilType: _soilType,
      growthStage: _growthStage,
      preference: _preference,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tabbed Pagination Navigation Bar
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            labelColor: AppColors.onPrimary,
            unselectedLabelColor: AppColors.onSurfaceVariant,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: const [
              Tab(text: 'Advisory Protocol'),
              Tab(text: 'Personalization'),
              Tab(text: 'Microclimate & Citations'),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Tab View Body
        SizedBox(
          height: 520,
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Advisory Protocol & Action Plan
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRiskBanner(recommendation),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.assignment_turned_in_outlined, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'ADVISORY TIMELINE PROTOCOL',
                          style: AppTextStyles.labelMd.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ...recommendation.items.map((item) => _buildActionCard(item)),
                  ],
                ),
              ),

              // Tab 2: Personalization & Soil Engine
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTogglesSection(),
                    const SizedBox(height: 20),
                    _buildMonitoringCard(recommendation),
                  ],
                ),
              ),

              // Tab 3: Microclimate & ICAR Citations
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCitationCard(recommendation),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTogglesSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                'PERSONALIZATION ENGINE PARAMETERS',
                style: AppTextStyles.labelSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSegmentRow(
            label: 'FARMER PREFERENCE',
            options: ['Organic', 'Chemical', 'Mixed'],
            currentValue: _preference,
            onSelected: (val) => setState(() => _preference = val),
          ),
          const SizedBox(height: 14),
          _buildSegmentRow(
            label: 'SOIL SUBSTRATE TYPE',
            options: ['Loamy', 'Clay', 'Sandy'],
            currentValue: _soilType,
            onSelected: (val) => setState(() => _soilType = val),
          ),
          const SizedBox(height: 14),
          _buildSegmentRow(
            label: 'CROP GROWTH STAGE',
            options: ['Vegetative', 'Flowering', 'Fruiting', 'Mature'],
            currentValue: _growthStage,
            onSelected: (val) => setState(() => _growthStage = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentRow({
    required String label,
    required List<String> options,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant, fontSize: 10)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: options.map((opt) {
            final selected = opt == currentValue;
            return ChoiceChip(
              label: Text(opt),
              selected: selected,
              onSelected: (_) => onSelected(opt),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: selected ? AppColors.onPrimary : AppColors.onSurface,
                fontSize: 12,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRiskBanner(AgronomyRecommendation rec) {
    if (rec.riskLevel.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade800, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BIOTIC THREAT RISK ASSESSMENT',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red.shade900),
                ),
                const SizedBox(height: 4),
                Text(
                  rec.riskLevel,
                  style: TextStyle(fontSize: 12, color: Colors.red.shade900, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(AgronomyRecommendationItem item) {
    final color = item.priority == RecommendationPriority.critical 
        ? Colors.redAccent 
        : (item.priority == RecommendationPriority.high ? Colors.orange : AppColors.primary);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt, size: 18, color: color),
              const SizedBox(width: 8),
              Text(item.title.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.priority.name.toUpperCase(),
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(item.description, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant, height: 1.4)),
          if (item.justifications.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Explainable Reasons: ${item.justifications.join(" • ")}',
                style: AppTextStyles.labelSm.copyWith(color: AppColors.primary, fontSize: 11),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMonitoringCard(AgronomyRecommendation rec) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.monitor_heart_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'EXPECTED RECOVERY & MONITORING',
                style: AppTextStyles.labelMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(rec.expectedRecovery, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(rec.monitoringSchedule, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildCitationCard(AgronomyRecommendation rec) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'AUTHORITATIVE ICAR CITATIONS',
                style: AppTextStyles.labelMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            rec.references.isNotEmpty
                ? rec.references
                : 'Recommendations are synchronized with Indian Council of Agricultural Research (ICAR) pathogen guidelines.',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant, height: 1.4),
          ),
        ],
      ),
    );
  }
}
