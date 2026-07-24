import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/core/providers/theme_provider.dart';
import 'package:krishios/features/home/presentation/screens/home_screen.dart';
import 'package:krishios/features/scan/presentation/screens/crop_scan_screen.dart';
import 'package:krishios/features/stats/presentation/screens/stats_screen.dart';
import 'package:krishios/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:krishios/features/tasks/presentation/screens/task_list_screen.dart';
import 'package:krishios/features/community/presentation/screens/community_screen.dart';
import 'package:krishios/features/scan/presentation/screens/chat_screen.dart';
import 'package:krishios/features/settings/presentation/screens/settings_screen.dart';

import 'web_sidebar.dart';
import 'web_top_bar.dart';
import 'web_right_panel.dart';

class WebDesktopShell extends ConsumerStatefulWidget {
  const WebDesktopShell({super.key});

  @override
  ConsumerState<WebDesktopShell> createState() => _WebDesktopShellState();
}

class _WebDesktopShellState extends ConsumerState<WebDesktopShell> {
  int _selectedIndex = 0;
  bool _isSidebarCollapsed = false;
  bool _isRightPanelOpen = true;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final bgCanvas = isDark ? const Color(0xFF121D12) : const Color(0xFFF6F4ED);

    return Scaffold(
      backgroundColor: bgCanvas,
      body: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.keyK, control: true): _openSearchDialog,
          const SingleActivator(LogicalKeyboardKey.keyK, meta: true): _openSearchDialog,
        },
        child: Focus(
          autofocus: true,
          child: Row(
            children: [
              // Left Fixed Collapsible Sidebar Navigation
              WebSidebar(
                selectedIndex: _selectedIndex,
                onItemSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                isCollapsed: _isSidebarCollapsed,
                onToggleCollapse: () {
                  setState(() {
                    _isSidebarCollapsed = !_isSidebarCollapsed;
                  });
                },
              ),

              // Middle Main Workstation Container
              Expanded(
                child: Column(
                  children: [
                    // Top Command Header Bar
                    WebTopBar(
                      isRightPanelOpen: _isRightPanelOpen,
                      onToggleRightPanel: () {
                        setState(() {
                          _isRightPanelOpen = !_isRightPanelOpen;
                        });
                      },
                    ),

                    // Main Workspace Body Container
                    Expanded(
                      child: Container(
                        color: bgCanvas,
                        child: SelectionArea(
                          child: _buildSelectedWorkspace(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Right Collapsible Telemetry Panel
              if (_isRightPanelOpen)
                WebRightPanel(
                  onClose: () {
                    setState(() {
                      _isRightPanelOpen = false;
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.search, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text('Quick Web App Search'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search crops, diseases, or tasks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedWorkspace() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const CropScanScreen();
      case 2:
        return const StatsScreen();
      case 3:
        return const HomeScreen();
      case 4:
        return const CalendarScreen();
      case 5:
        return const TaskListScreen();
      case 6:
        return const CommunityScreen();
      case 7:
        return const ChatScreen(
          scanId: 'web_general',
          cropName: 'General Inquiry',
          diagnosis: 'Web Advisory',
        );
      case 8:
        return const SettingsScreen();
      default:
        return const HomeScreen();
    }
  }
}
