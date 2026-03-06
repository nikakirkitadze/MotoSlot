import 'package:app_links/app_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/auth/presentation/cubit/auth_cubit.dart';
import 'package:moto_slot/modules/auth/presentation/cubit/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _handledEmailLink = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0, 0.6, curve: Curves.easeOut)),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0, 0.6, curve: Curves.easeOutCubic)),
    );
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _handleInitialLink();
    });
  }

  Future<void> _handleInitialLink() async {
    try {
      final appLinks = AppLinks();
      final initialUri = await appLinks.getInitialLink();

      if (initialUri != null &&
          FirebaseAuth.instance
              .isSignInWithEmailLink(initialUri.toString())) {
        _handledEmailLink = true;
        if (mounted) {
          context
              .read<AuthCubit>()
              .signInWithEmailLink(initialUri.toString());
        }
        return;
      }
    } catch (_) {
      // No initial link or error — fall through to normal auth check
    }

    if (mounted) {
      context.read<AuthCubit>().checkAuthStatus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (listenerContext, state) {
        if (state.status == StateStatus.success ||
            (_handledEmailLink && state.status == StateStatus.failure)) {
          final navigator = GoRouter.of(listenerContext);
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (!mounted) return;
            if (state.isAuthenticated) {
              if (state.needsProfileCompletion) {
                navigator.go('/complete-profile');
              } else if (state.isAdmin) {
                navigator.go('/admin');
              } else {
                navigator.go('/home');
              }
            } else {
              navigator.go('/login');
            }
          });
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2563EB),
                Color(0xFF1E40AF),
              ],
            ),
          ),
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.borderRadiusXl,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 32,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'MS',
                          style: AppTypography.displayLarge.copyWith(
                            color: AppColors.primary,
                            fontSize: 36,
                          ),
                        ),
                      ),
                    ),
                    AppSpacing.verticalLg,
                    Text(
                      'MotoSlot',
                      style: AppTypography.displayLarge.copyWith(
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    AppSpacing.verticalSm,
                    Text(
                      'Motorcycle Driving Academy',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                        letterSpacing: 0.5,
                      ),
                    ),
                    AppSpacing.verticalXxl,
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withValues(alpha: 0.8),
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
  }
}
