import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/providers/theme_provider.dart';

class WebRightPanel extends ConsumerWidget {
  final VoidCallback onClose;

  const WebRightPanel({super.key, required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final bgCanvas = isDark ? const Color(0xFF1B2E1A) : const Color(0xFFF6F4ED);
    final cardBg = isDark ? const Color(0xFF121D12) : Colors.white;
    final borderColor = isDark ? const Color(0x33F6F4ED) : const Color(0x1F1A2919);
    final textPrimary = isDark ? const Color(0xFFF6F4ED) : const Color(0xFF1A2919);
    final textSecondary = isDark ? const Color(0xFFA4B8A2) : const Color(0xFF4B5E4A);
    final oliveDark = isDark ? const Color(0xFF2E4D2C) : const Color(0xFF233B22);

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: bgCanvas,
        border: Border(
          left: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(Icons.analytics_outlined, size: 20, color: textPrimary),
                const SizedBox(width: 10),
                Text(
                  'Telemetry & Climate',
                  style: TextStyle(
                    fontFamily: 'Serif',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close_rounded, size: 18, color: textSecondary),
                  onPressed: onClose,
                  tooltip: 'Close Right Panel',
                ),
              ],
            ),
          ),
          Divider(height: 1, color: borderColor),

          // Scrollable Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Real-time Field Telemetry Card
                _buildCard(
                  cardBg: cardBg,
                  borderColor: borderColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.sensors_rounded, size: 16, color: oliveDark),
                          const SizedBox(width: 8),
                          Text(
                            'FIELD TELEMETRY SENSORS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: oliveDark,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildMetricRow('Soil Moisture', '68% Optimal', Colors.green, textPrimary, textSecondary),
                      const SizedBox(height: 10),
                      _buildMetricRow('Foliage Temp', '24.5 °C', textPrimary, textPrimary, textSecondary),
                      const SizedBox(height: 10),
                      _buildMetricRow('Ambient Humidity', '72%', textPrimary, textPrimary, textSecondary),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Biotic Risk Radar Card
                _buildCard(
                  cardBg: cardBg,
                  borderColor: borderColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.shield_moon_outlined, size: 16, color: oliveDark),
                          const SizedBox(width: 8),
                          Text(
                            'BIOTIC RISK RADAR',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: oliveDark,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, size: 18, color: Colors.orange),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'High humidity alert: Fungal spore germination risk for Solanaceae family.',
                                style: TextStyle(fontSize: 11, color: isDark ? Colors.white : Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Spraying Window Recommendation Card
                _buildCard(
                  cardBg: cardBg,
                  borderColor: borderColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.water_drop_outlined, size: 16, color: oliveDark),
                          const SizedBox(width: 8),
                          Text(
                            'OPTIMAL SPRAYING WINDOW',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: oliveDark,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('06:00 AM - 09:00 AM', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary)),
                              Text('Low wind speed (4 km/h)', style: TextStyle(fontSize: 11, color: textSecondary)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'IDEAL',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child, required Color cardBg, required Color borderColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }

  Widget _buildMetricRow(String label, String value, Color valueColor, Color textPrimary, Color textSecondary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: textSecondary)),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: valueColor)),
      ],
    );
  }
}
