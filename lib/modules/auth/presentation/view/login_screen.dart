import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/app/theme.dart';
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
              backgroundColor: AppTheme.errorColor,
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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  // Logo
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          'MS',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    context.l10n.welcomeToMotoSlot,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.signInSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  AppTextField(
                    label: context.l10n.email,
                    hint: context.l10n.emailHint,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.emailValidator(context),
                    prefixIcon: const Icon(Icons.email_outlined, size: 20),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: context.l10n.password,
                    hint: context.l10n.passwordHint,
                    controller: _passwordController,
                    obscureText: true,
                    validator: Validators.passwordValidator(context),
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _onLogin(),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppTextButton(
                      text: context.l10n.forgotPassword,
                      onPressed: () => context.push('/forgot-password'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return AppButton(
                        text: context.l10n.signIn,
                        onPressed: _onLogin,
                        isLoading: state.isLoading,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.l10n.dontHaveAccount,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      AppTextButton(
                        text: context.l10n.register,
                        onPressed: () => context.push('/register'),
                      ),
                    ],
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
