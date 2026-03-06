import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/locale/cubit_l10n.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/core/utils/validators.dart';
import 'package:moto_slot/core/widgets/widgets.dart';
import 'package:moto_slot/modules/auth/presentation/cubit/auth_cubit.dart';
import 'package:moto_slot/modules/auth/presentation/cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendLink() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().sendSignInLink(_emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == StateStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizeMessage(context, state.errorMessage!)),
              backgroundColor: AppColors.error,
            ),
          );
          context.read<AuthCubit>().clearError();
        }
        if (state.isAuthenticated) {
          if (state.needsProfileCompletion) {
            context.go('/complete-profile');
          } else if (state.isAdmin) {
            context.go('/admin');
          } else {
            context.go('/home');
          }
        }
        if (state.isEmailLinkSent) {
          context.push('/email-link-sent');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 48),
                  // Logo
                  FadeInWidget(
                    child: Center(
                      child: AppLogo(
                        variant: AppLogoVariant.iconWithText,
                        iconSize: 48,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  FadeInWidget(
                    delay: const Duration(milliseconds: 100),
                    child: Text(
                      context.l10n.logIn,
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.navy,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  AppSpacing.verticalSm,
                  FadeInWidget(
                    delay: const Duration(milliseconds: 150),
                    child: Text(
                      context.l10n.signInSubtitle,
                      style: AppTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email field
                  FadeInWidget(
                    delay: const Duration(milliseconds: 200),
                    child: AppTextField(
                      hint: context.l10n.emailAddress,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.emailValidator(context),
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _onSendLink(),
                    ),
                  ),
                  AppSpacing.verticalLg,

                  // Send Link button
                  FadeInWidget(
                    delay: const Duration(milliseconds: 250),
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return NavyButton(
                          text: context.l10n.sendSignInLink,
                          onPressed: _onSendLink,
                          isLoading: state.isLoading,
                          icon: Icons.mail_outline_rounded,
                        );
                      },
                    ),
                  ),
                  AppSpacing.verticalLg,

                  // OR divider
                  FadeInWidget(
                    delay: const Duration(milliseconds: 300),
                    child: _buildOrDivider(context),
                  ),
                  AppSpacing.verticalLg,

                  // Apple Sign In (iOS only)
                  if (Platform.isIOS) ...[
                    FadeInWidget(
                      delay: const Duration(milliseconds: 350),
                      child: _SocialButton(
                        text: context.l10n.continueWithApple,
                        icon: Icons.apple,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        onPressed: () =>
                            context.read<AuthCubit>().signInWithApple(),
                      ),
                    ),
                    AppSpacing.verticalMd,
                  ],

                  // Google Sign In
                  FadeInWidget(
                    delay: Duration(
                        milliseconds: Platform.isIOS ? 400 : 350),
                    child: _SocialButton(
                      text: context.l10n.continueWithGoogle,
                      icon: null,
                      googleLogo: true,
                      backgroundColor: AppColors.surface,
                      textColor: AppColors.textPrimary,
                      borderColor: AppColors.border,
                      onPressed: () =>
                          context.read<AuthCubit>().signInWithGoogle(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrDivider(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            context.l10n.orContinueWith,
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}

class _SocialButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final bool googleLogo;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback? onPressed;

  const _SocialButton({
    required this.text,
    this.icon,
    this.googleLogo = false,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.onPressed,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: AppRadius.borderRadiusMd,
            border: widget.borderColor != null
                ? Border.all(color: widget.borderColor!, width: 1.5)
                : null,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null)
                  Icon(widget.icon, size: 22, color: widget.textColor),
                if (widget.googleLogo)
                  Text(
                    'G',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: widget.textColor,
                    ),
                  ),
                const SizedBox(width: 12),
                Text(
                  widget.text,
                  style: AppTypography.button
                      .copyWith(color: widget.textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
