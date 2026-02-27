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
                  const SizedBox(height: 32),
                  FadeInWidget(
                    delay: const Duration(milliseconds: 200),
                    child: AppTextField(
                      hint: context.l10n.emailAddress,
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
                      hint: context.l10n.password,
                      controller: _passwordController,
                      obscureText: true,
                      validator: Validators.passwordValidator(context),
                      prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _onLogin(),
                    ),
                  ),
                  AppSpacing.verticalLg,
                  FadeInWidget(
                    delay: const Duration(milliseconds: 300),
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return NavyButton(
                          text: context.l10n.logIn,
                          onPressed: _onLogin,
                          isLoading: state.isLoading,
                        );
                      },
                    ),
                  ),
                  AppSpacing.verticalSm,
                  Center(
                    child: GhostButton(
                      text: context.l10n.forgotPassword,
                      onPressed: () => context.push('/forgot-password'),
                    ),
                  ),
                  AppSpacing.verticalMd,
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
                          text: context.l10n.signUp,
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
