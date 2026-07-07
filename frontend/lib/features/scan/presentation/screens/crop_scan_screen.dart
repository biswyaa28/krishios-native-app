import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class CropScanScreen extends StatelessWidget {
  const CropScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: AppColors.surface.withValues(alpha: 0.8),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 64,
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back, color: AppColors.onSurface),
                    const SizedBox(width: 12),
                    Text('KrishiOS', style: AppTextStyles.headlineMd),
                    const Spacer(),
                    const Icon(Icons.help_outline, color: AppColors.onSurface),
                  ],
                ),
              ),
            ),
          ),
        ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              'Identify Crop Disease',
              style: AppTextStyles.headlineLgMobile,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Text(
              'Point your camera at the affected leaves or stems for a real-time AI diagnosis.',
              style: AppTextStyles.bodyMd,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: const Color(0xFF1A2A1A),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.agriculture,
                                  size: 80,
                                  color: Colors.white.withValues(alpha: 0.3)),
                              const SizedBox(height: 8),
                              Text(
                                'Camera Preview',
                                style: AppTextStyles.labelMd
                                    .copyWith(color: Colors.white54),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: 256,
                        height: 256,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              child: _CornerBracket(
                                isTop: true,
                                isLeft: true,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: _CornerBracket(
                                isTop: true,
                                isLeft: false,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: _CornerBracket(
                                isTop: false,
                                isLeft: true,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: _CornerBracket(
                                isTop: false,
                                isLeft: false,
                              ),
                            ),
                            _ScanningLine(),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 24,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.flash_off,
                                  color: Colors.white, size: 24),
                              SizedBox(
                                width: 16,
                                child: Divider(color: Colors.white24),
                              ),
                              Text('1x',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(
                                width: 16,
                                child: Divider(color: Colors.white24),
                              ),
                              Icon(Icons.zoom_in,
                                  color: Colors.white, size: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('Capture Photo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      textStyle: AppTextStyles.labelMd,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.image),
                    label: const Text('Upload from Gallery'),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.secondaryContainer,
                      foregroundColor: AppColors.onSecondaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      side: BorderSide.none,
                      textStyle: AppTextStyles.labelMd,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  }
}

class _CornerBracket extends StatelessWidget {
  final bool isTop;
  final bool isLeft;

  const _CornerBracket({required this.isTop, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: AppColors.tertiaryFixedDim, width: 4)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: AppColors.tertiaryFixedDim, width: 4)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: AppColors.tertiaryFixedDim, width: 4)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: AppColors.tertiaryFixedDim, width: 4)
              : BorderSide.none,
        ),
      ),
    );
  }
}

class _ScanningLine extends StatefulWidget {
  @override
  State<_ScanningLine> createState() => _ScanningLineState();
}

class _ScanningLineState extends State<_ScanningLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: _animation.value * 256,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.tertiaryFixedDim,
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.tertiaryFixedDim.withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
