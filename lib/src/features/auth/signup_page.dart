import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'dart:math' as math;

import '../../core/components/glass_card.dart';
import '../../core/components/app_notification.dart';
import 'auth_provider.dart';
import 'auth_widgets.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> with TickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_emailController.text.isEmpty) {
      AppNotification.show(
        context,
        title: 'Input Required',
        message: 'Please enter your email to create an account',
        type: NotificationType.error,
      );
      return;
    }

    final success = await ref
        .read(authProvider.notifier)
        .signup(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
        );

    if (success && mounted) {
      AppNotification.show(
        context,
        title: 'Account Created',
        message: 'Welcome to Startfront! Your account was registered successfully.',
        type: NotificationType.success,
      );
      context.go('/');
    } else if (mounted) {
      AppNotification.show(
        context,
        title: 'Signup Failed',
        message: 'Username or email already exists. Please try again.',
        type: NotificationType.error,
      );
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
                        const Color(0xFFEC4899),
                        const Color(0xFF6366F1),
                        const Color(0xFF8B5CF6),
                        const Color(0xFFBE185D),
                      ],
                    ),
                    child: Container(),
                  ),
                  CustomPaint(
                    painter: AuroraPainter(
                      animationValue: _backgroundController.value * 2 * math.pi,
                      color: const Color(0xFFEC4899),
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
                      child: Hero(
                        tag: 'auth_logo',
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFEC4899),
                                Color(0xFFBE185D),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFEC4899).withValues(alpha: 0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 42),
                        ),
                      ),
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
                              'Create Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Begin your advanced admin journey',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.4),
                                fontSize: 14,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 40),

                            GlowingTextField(
                              label: 'Full Name',
                              controller: _nameController,
                              hint: 'John Doe',
                              icon: Icons.person_outline_rounded,
                            ),
                            const SizedBox(height: 20),

                            GlowingTextField(
                              label: 'Work Email',
                              controller: _emailController,
                              hint: 'john@synergy.io',
                              icon: Icons.alternate_email_rounded,
                            ),
                            const SizedBox(height: 20),

                            GlowingTextField(
                              label: 'Password',
                              controller: _passwordController,
                              hint: '••••••••',
                              icon: Icons.lock_outline_rounded,
                              isPassword: true,
                              isVisible: _isPasswordVisible,
                              onVisibilityToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                            ),
                            const SizedBox(height: 40),

                            _buildSignupButton(authState.isLoading),

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

  Widget _buildSignupButton(bool isLoading) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setInnerState) {
        return MouseRegion(
          cursor: isLoading ? SystemMouseCursors.basic : SystemMouseCursors.click,
          onEnter: (_) => setInnerState(() => isHovered = true),
          onExit: (_) => setInnerState(() => isHovered = false),
          child: GestureDetector(
            onTap: isLoading ? null : _handleSignup,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.only(
                bottom: isHovered ? 3.0 : 0.0,
                top: isHovered ? 0.0 : 3.0,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isHovered
                        ? [
                            const Color(0xFFFF6EB5),
                            const Color(0xFFEC4899),
                          ]
                        : [
                            const Color(0xFFEC4899),
                            const Color(0xFFBE185D),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEC4899).withValues(
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
                                'GET STARTED',
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
                                child: const Icon(
                                  Icons.rocket_launch_rounded,
                                  color: Colors.white,
                                  size: 18,
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
          "Already have an account?",
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
        HoverTextButton(
          text: 'Sign In',
          onTap: () => context.pop(),
          color: const Color(0xFFEC4899),
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ],
    );
  }
}
