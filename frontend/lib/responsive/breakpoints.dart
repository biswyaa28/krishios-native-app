// KrishiOS Responsive Breakpoints
// Used to determine the correct layout shell for the current device/window size.

/// Screen width breakpoints (in logical pixels)
class Breakpoints {
  /// Anything below this is considered a phone
  static const double mobile = 600;

  /// Between mobile and this is considered a tablet
  static const double tablet = 900;

  /// At or above this is considered desktop
  static const double desktop = 1200;
}

/// Platform layout type determined by screen width
enum PlatformLayout {
  mobile,
  tablet,
  desktop,
}

/// Helper to get layout type from screen width
PlatformLayout getPlatformLayout(double width) {
  if (width >= Breakpoints.desktop) return PlatformLayout.desktop;
  if (width >= Breakpoints.tablet) return PlatformLayout.tablet;
  return PlatformLayout.mobile;
}
