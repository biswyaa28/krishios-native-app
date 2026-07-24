import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'breakpoints.dart';
import 'web/web_desktop_shell.dart';

/// ResponsiveShell renders the mobile shell for Android, and WebDesktopShell for Web.
class ResponsiveShell extends ConsumerStatefulWidget {
  final Widget mobileShell;

  const ResponsiveShell({super.key, required this.mobileShell});

  @override
  ConsumerState<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends ConsumerState<ResponsiveShell> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = kIsWeb || width >= Breakpoints.tablet;

    if (!isDesktop) {
      return widget.mobileShell;
    }

    return const WebDesktopShell();
  }
}
