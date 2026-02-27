import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
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
      },
      child: AppScaffold(
        hasBackButton: true,
        body: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                FadeInWidget(
                  child: Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                AppSpacing.verticalLg,
                FadeInWidget(
                  delay: const Duration(milliseconds: 100),
                  child: Text(
                    context.l10n.forgotPasswordTitle,
                    style: AppTypography.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                AppSpacing.verticalSm,
                FadeInWidget(
                  delay: const Duration(milliseconds: 150),
                  child: Text(
                    context.l10n.forgotPasswordSubtitle,
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                AppSpacing.verticalXl,
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state.isPasswordResetSent) {
                      return _buildSuccessState();
                    }
                    return FadeInWidget(
                      delay: const Duration(milliseconds: 200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTextField(
                            label: context.l10n.email,
                            hint: context.l10n.emailAddressHint,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.emailValidator(context),
                            prefixIcon: const Icon(Icons.email_outlined, size: 20),
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _onSubmit(),
                          ),
                          AppSpacing.verticalLg,
                          PrimaryButton(
                            text: context.l10n.sendResetLink,
                            onPressed: _onSubmit,
                            isLoading: state.isLoading,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    return FadeInWidget(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.successLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              size: 40,
              color: AppColors.success,
            ),
          ),
          AppSpacing.verticalMd,
          Text(
            context.l10n.emailSent,
            style: AppTypography.headlineSmall.copyWith(color: AppColors.success),
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalSm,
          Text(
            context.l10n.checkInboxForReset,
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalLg,
          PrimaryButton(
            text: context.l10n.backToLogin,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
