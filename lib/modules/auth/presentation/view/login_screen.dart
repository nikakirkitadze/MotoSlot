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
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signIn(
            email: _emailController.text,
            password: _passwordController.text,
          );
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
          if (state.isAdmin) {
            context.go('/admin');
          } else {
            context.go('/home');
          }
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
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: AppRadius.borderRadiusXl,
                          boxShadow: AppShadows.primary,
                        ),
                        child: Center(
                          child: Text(
                            'MS',
                            style: AppTypography.headlineLarge.copyWith(
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.verticalLg,
                  FadeInWidget(
                    delay: const Duration(milliseconds: 100),
                    child: Text(
                      context.l10n.welcomeToMotoSlot,
                      style: AppTypography.displayMedium,
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
                  const SizedBox(height: 40),
                  FadeInWidget(
                    delay: const Duration(milliseconds: 200),
                    child: AppTextField(
                      label: context.l10n.email,
                      hint: context.l10n.emailHint,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.emailValidator(context),
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  AppSpacing.verticalMd,
                  FadeInWidget(
                    delay: const Duration(milliseconds: 250),
                    child: AppTextField(
                      label: context.l10n.password,
                      hint: context.l10n.passwordHint,
                      controller: _passwordController,
                      obscureText: true,
                      validator: Validators.passwordValidator(context),
                      prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _onLogin(),
                    ),
                  ),
                  AppSpacing.verticalSm,
                  Align(
                    alignment: Alignment.centerRight,
                    child: GhostButton(
                      text: context.l10n.forgotPassword,
                      onPressed: () => context.push('/forgot-password'),
                    ),
                  ),
                  AppSpacing.verticalLg,
                  FadeInWidget(
                    delay: const Duration(milliseconds: 300),
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return PrimaryButton(
                          text: context.l10n.signIn,
                          onPressed: _onLogin,
                          isLoading: state.isLoading,
                        );
                      },
                    ),
                  ),
                  AppSpacing.verticalLg,
                  FadeInWidget(
                    delay: const Duration(milliseconds: 350),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.l10n.dontHaveAccount,
                          style: AppTypography.bodyMedium,
                        ),
                        GhostButton(
                          text: context.l10n.register,
                          onPressed: () => context.push('/register'),
                        ),
                      ],
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
}
