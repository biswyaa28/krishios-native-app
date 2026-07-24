import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/shared/providers/auth_provider.dart';
import 'package:krishios/shared/presentation/providers/language_provider.dart';
import 'package:krishios/shared/services/translation_service.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    final authService = ref.read(authServiceProvider);
    try {
      if (_isLogin) {
        await authService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        await authService.signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _googleSignIn() async {
    setState(() => _loading = true);
    final authService = ref.read(authServiceProvider);
    try {
      await authService.signInWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign-In failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _bypassGuest() {
    ref.read(isGuestProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    final activeLang = ref.watch(languageProvider);
    final width = MediaQuery.of(context).size.width;
    final isDesktop = kIsWeb || width >= 900;

    if (isDesktop) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F4ED),
        body: Row(
          children: [
            // Left Hero Column (Dark Olive Editorial Card)
            Expanded(
              flex: 5,
              child: Container(
                color: const Color(0xFF233B22),
                padding: const EdgeInsets.all(60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/brand/app_icon.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'The Intelligence of the Earth,',
                      style: TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 42,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFF6F4ED),
                        height: 1.1,
                      ),
                    ),
                    const Text(
                      'On Your Device.',
                      style: TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 42,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFA4B8A2),
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Empowering farmers with instantaneous crop disease diagnostics, local ONNX neural edge AI, multi-lingual Kavya voice advisory, and zero internet dependency.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFA4B8A2),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        _buildFeatureBadge('< 1 sec Latency'),
                        const SizedBox(width: 12),
                        _buildFeatureBadge('100% Edge AI'),
                        const SizedBox(width: 12),
                        _buildFeatureBadge('AES-256 Encrypted'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Right Form Column (Centered Form Container)
            Expanded(
              flex: 6,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 440),
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0x1F1A2919)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0F1A2919),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: _buildForm(activeLang),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Mobile Layout (Unchanged)
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 440),
              child: _buildForm(activeLang),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2E1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x33F6F4ED)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFF6F4ED)),
      ),
    );
  }

  Widget _buildForm(String activeLang) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/brand/app_icon.png',
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            TranslationService.translate('app_title', activeLang),
            style: AppTextStyles.headlineLgMobile.copyWith(color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 28),
        if (!_isLogin) ...[
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: TranslationService.translate('full_name', activeLang),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
        ],
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: TranslationService.translate('email', activeLang),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: TranslationService.translate('password', activeLang),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: _loading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF233B22),
              foregroundColor: const Color(0xFFF6F4ED),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _loading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(_isLogin ? 'Sign In' : 'Create Account', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => setState(() => _isLogin = !_isLogin),
          child: Text(
            _isLogin ? 'Create an account' : 'Already have an account? Sign in',
            style: const TextStyle(color: Color(0xFF233B22), fontSize: 13),
          ),
        ),
        const Divider(height: 32),
        OutlinedButton.icon(
          onPressed: _loading ? null : _googleSignIn,
          icon: const Icon(Icons.g_mobiledata, size: 24),
          label: const Text('Continue with Google'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _bypassGuest,
          child: const Text(
            'Continue as Guest (Bypass Sign-In)',
            style: TextStyle(color: Color(0xFF4B5E4A), fontSize: 12),
          ),
        ),
      ],
    );
  }
}
