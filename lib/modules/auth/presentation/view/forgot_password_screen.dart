import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_slot/app/theme.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/locale/cubit_l10n.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/core/utils/validators.dart';
import 'package:moto_slot/core/widgets/widgets.dart';
import 'package:moto_slot/modules/auth/presentation/cubit/auth_cubit.dart';
import 'package:moto_slot/modules/auth/presentation/cubit/auth_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().resetPassword(_emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(context.l10n.resetPassword),
        backgroundColor: Colors.white,
      ),
      body: BlocListener<AuthCubit, AuthState>(
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
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  const Icon(
                    Icons.lock_reset,
                    size: 64,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    context.l10n.forgotPasswordTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n.forgotPasswordSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state.isPasswordResetSent) {
                        return _buildSuccessState();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTextField(
                            label: context.l10n.email,
                            hint: context.l10n.emailAddressHint,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.emailValidator(context),
                            prefixIcon:
                                const Icon(Icons.email_outlined, size: 20),
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _onSubmit(),
                          ),
                          const SizedBox(height: 24),
                          AppButton(
                            text: context.l10n.sendResetLink,
                            onPressed: _onSubmit,
                            isLoading: state.isLoading,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 64,
          color: AppTheme.successColor,
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.emailSent,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.successColor,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.checkInboxForReset,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        AppButton(
          text: context.l10n.backToLogin,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
