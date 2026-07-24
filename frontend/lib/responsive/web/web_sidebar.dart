import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/providers/theme_provider.dart';
import 'package:krishios/shared/presentation/providers/language_provider.dart';
import 'package:krishios/shared/services/translation_service.dart';

class WebSidebarItem {
  final IconData icon;
  final String key;
  final String fallbackLabel;
  final String? badge;

  const WebSidebarItem({
    required this.icon,
    required this.key,
    required this.fallbackLabel,
    this.badge,
  });
}

class WebSidebar extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;

  const WebSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.isCollapsed,
    required this.onToggleCollapse,
  });

  static const List<WebSidebarItem> items = [
    WebSidebarItem(icon: Icons.dashboard_outlined, key: 'home_tab', fallbackLabel: 'Dashboard'),
    WebSidebarItem(icon: Icons.qr_code_scanner_rounded, key: 'scan_tab', fallbackLabel: 'Crop Scan', badge: 'AI'),
    WebSidebarItem(icon: Icons.analytics_outlined, key: 'stats_tab', fallbackLabel: 'Analytics'),
    WebSidebarItem(icon: Icons.wb_sunny_outlined, key: 'weather', fallbackLabel: 'Weather'),
    WebSidebarItem(icon: Icons.calendar_today_outlined, key: 'calendar', fallbackLabel: 'Calendar'),
    WebSidebarItem(icon: Icons.task_alt_rounded, key: 'tasks', fallbackLabel: 'Tasks'),
    WebSidebarItem(icon: Icons.forum_outlined, key: 'community_tab', fallbackLabel: 'Community'),
    WebSidebarItem(icon: Icons.smart_toy_outlined, key: 'ask_ai', fallbackLabel: 'Kavya AI'),
    WebSidebarItem(icon: Icons.settings_outlined, key: 'settings_title', fallbackLabel: 'Settings'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final activeLang = ref.watch(languageProvider);

    final bgCanvas = isDark ? const Color(0xFF1B2E1A) : const Color(0xFFF6F4ED);
    final borderColor = isDark ? const Color(0x33F6F4ED) : const Color(0x1F1A2919);
    final textPrimary = isDark ? const Color(0xFFF6F4ED) : const Color(0xFF1A2919);
    final textSecondary = isDark ? const Color(0xFFA4B8A2) : const Color(0xFF4B5E4A);
    final activeBg = isDark ? const Color(0xFF2E4D2C) : const Color(0xFF233B22);
    final activeFg = const Color(0xFFF6F4ED);
    final cardBg = isDark ? const Color(0xFF121D12) : Colors.white;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: isCollapsed ? 72 : 240,
      decoration: BoxDecoration(
        color: bgCanvas,
        border: Border(
          right: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Header Logo & Toggle
          Container(
            height: 64,
            padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 12 : 16),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/brand/app_icon.png',
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                  ),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  Text(
                    TranslationService.translate('app_title', activeLang),
                    style: TextStyle(
                      fontFamily: 'Serif',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left_rounded,
                      color: textSecondary,
                      size: 20,
                    ),
                    onPressed: onToggleCollapse,
                    tooltip: 'Collapse Sidebar',
                  ),
                ],
              ],
            ),
          ),
          if (isCollapsed)
            IconButton(
              icon: Icon(
                Icons.chevron_right_rounded,
                color: textSecondary,
                size: 20,
              ),
              onPressed: onToggleCollapse,
              tooltip: 'Expand Sidebar',
            ),
          Divider(height: 1, color: borderColor),

          // Navigation List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = index == selectedIndex;
                final translated = TranslationService.translate(item.key, activeLang);
                final label = (translated == item.key) ? item.fallbackLabel : translated;

                if (isCollapsed) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Center(
                      child: Tooltip(
                        message: label,
                        child: InkWell(
                          onTap: () => onItemSelected(index),
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected ? activeBg : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              item.icon,
                              size: 20,
                              color: isSelected ? activeFg : textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: InkWell(
                    onTap: () => onItemSelected(index),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? activeBg : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            size: 18,
                            color: isSelected ? activeFg : textSecondary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? activeFg : textPrimary,
                              ),
                            ),
                          ),
                          if (item.badge != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected ? activeFg.withValues(alpha: 0.2) : activeBg.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.badge!,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? activeFg : textPrimary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // User Profile Footer Card
          if (!isCollapsed)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: activeBg.withValues(alpha: 0.2),
                    child: Icon(Icons.person_rounded, size: 18, color: textPrimary),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Farmer Pro',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimary),
                        ),
                        Text(
                          'Field Operator',
                          style: TextStyle(fontSize: 10, color: textSecondary),
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
}
