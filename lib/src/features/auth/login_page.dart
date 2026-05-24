import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'dart:math' as math;

import '../../core/constants/theme.dart';
import '../../core/components/glass_card.dart';
import '../../core/components/app_notification.dart';
import 'auth_provider.dart';
import 'auth_widgets.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  late AnimationController _backgroundController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty) {
      AppNotification.show(
        context,
        title: 'Input Required',
        message: 'Please enter your email to continue',
        type: NotificationType.error,
      );
      return;
    }

    final success = await ref
        .read(authProvider.notifier)
        .login(
          _emailController.text,
          _passwordController.text,
        );

    if (success && mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: Stack(
        children: [
          // Cinematic Background
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Stack(
                children: [
                  CustomPaint(
                    painter: MeshGradientPainter(
                      animationValue: _backgroundController.value * 2 * math.pi,
                      colors: [
                        AppTheme.primaryColor,
                        const Color(0xFF6366F1),
                        const Color(0xFFEC4899),
                        const Color(0xFF00D2D2),
                      ],
                    ),
                    child: Container(),
                  ),
                  CustomPaint(
                    painter: AuroraPainter(
                      animationValue: _backgroundController.value * 2 * math.pi,
                      color: AppTheme.primaryColor,
                    ),
                    child: Container(),
                  ),
                ],
              );
            },
          ),

          // Ultra Blur Layer
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(color: Colors.transparent),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Staggered Entrance Elements
                    StaggeredEntrance(
                      index: 0,
                      child: _buildHeader(),
                    ),
                    const SizedBox(height: 48),

                    StaggeredEntrance(
                      index: 1,
                      child: GlassCard(
                        padding: const EdgeInsets.all(40),
                        backgroundOpacity: 0.1,
                        borderOpacity: 0.15,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome Back',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sign in to your dashboard',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.4),
                                fontSize: 14,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 40),

                            GlowingTextField(
                              label: 'Email Address',
                              controller: _emailController,
                              hint: 'admin@synergy.io',
                              icon: Icons.alternate_email_rounded,
                            ),
                            const SizedBox(height: 24),

                            GlowingTextField(
                              label: 'Password',
                              controller: _passwordController,
                              hint: '••••••••',
                              icon: Icons.lock_outline_rounded,
                              isPassword: true,
                              isVisible: _isPasswordVisible,
                              onVisibilityToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: HoverTextButton(
                                text: 'Forgot Password?',
                                onTap: () {},
                                color: AppTheme.primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),

                            _buildLoginButton(authState.isLoading),

                            const SizedBox(height: 32),

                            Center(
                              child: _buildFooterLink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Hero(
          tag: 'auth_logo',
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withValues(alpha: 0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 42),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'STARTFRONT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 8,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'ULTRA-PREMIUM ADMIN ENGINE',
            style: TextStyle(
              color: AppTheme.primaryColor.withValues(alpha: 0.8),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(bool isLoading) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setInnerState) {
        return MouseRegion(
          cursor: isLoading ? SystemMouseCursors.basic : SystemMouseCursors.click,
          onEnter: (_) => setInnerState(() => isHovered = true),
          onExit: (_) => setInnerState(() => isHovered = false),
          child: GestureDetector(
            onTap: isLoading ? null : _handleLogin,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.only(bottom: isHovered ? 3.0 : 0.0, top: isHovered ? 0.0 : 3.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isHovered
                        ? [
                            AppTheme.primaryColor.withValues(alpha: 1.0),
                            const Color(0xFF00B8B8),
                          ]
                        : [
                            AppTheme.primaryColor,
                            const Color(0xFF009797),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(
                        alpha: isHovered ? 0.6 : 0.3,
                      ),
                      blurRadius: isHovered ? 32 : 15,
                      spreadRadius: isHovered ? 4 : 0,
                      offset: Offset(0, isHovered ? 12 : 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'SIGN IN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOutCubic,
                                width: isHovered ? 16 : 12,
                              ),
                              AnimatedSlide(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOutCubic,
                                offset: Offset(isHovered ? 0.2 : 0.0, 0),
                                child: SvgPicture.asset(
                                  'assets/icons/login.svg',
                                  width: 32,
                                  height: 32,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
        HoverTextButton(
          text: 'Join Now',
          onTap: () => context.push('/signup'),
          color: AppTheme.primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ],
    );
  }
}
