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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
            email: _emailController.text,
            password: _passwordController.text,
            fullName: _nameController.text,
            phone: _phoneController.text,
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
          context.go('/home');
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
                AppSpacing.verticalSm,
                FadeInWidget(
                  child: Center(
                    child: AppLogo(
                      variant: AppLogoVariant.iconWithMS,
                      iconSize: 48,
                    ),
                  ),
                ),
                AppSpacing.verticalMd,
                FadeInWidget(
                  delay: const Duration(milliseconds: 50),
                  child: Text(
                    context.l10n.joinMotoSlot,
                    style: AppTypography.displayMedium.copyWith(
                      color: AppColors.navy,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                AppSpacing.verticalSm,
                FadeInWidget(
                  delay: const Duration(milliseconds: 100),
                  child: Text(
                    context.l10n.createAccountSubtitle,
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                AppSpacing.verticalLg,
                StaggeredItem(
                  index: 0,
                  child: AppTextField(
                    label: context.l10n.fullName,
                    hint: context.l10n.fullNameHint,
                    controller: _nameController,
                    validator: Validators.nameValidator(context),
                    prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                AppSpacing.verticalMd,
                StaggeredItem(
                  index: 1,
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
                StaggeredItem(
                  index: 2,
                  child: AppTextField(
                    label: context.l10n.phoneNumber,
                    hint: context.l10n.phoneHint,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: Validators.phoneValidator(context),
                    prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                AppSpacing.verticalMd,
                StaggeredItem(
                  index: 3,
                  child: AppTextField(
                    label: context.l10n.password,
                    hint: context.l10n.createPassword,
                    controller: _passwordController,
                    obscureText: true,
                    validator: Validators.passwordValidator(context),
                    prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                AppSpacing.verticalMd,
                StaggeredItem(
                  index: 4,
                  child: AppTextField(
                    label: context.l10n.confirmPassword,
                    hint: context.l10n.confirmPasswordHint,
                    controller: _confirmPasswordController,
                    obscureText: true,
                    validator: Validators.confirmPasswordValidator(
                      context,
                      _passwordController.text,
                    ),
                    prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _onRegister(),
                  ),
                ),
                AppSpacing.verticalLg,
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return NavyButton(
                      text: context.l10n.createAccount,
                      onPressed: _onRegister,
                      isLoading: state.isLoading,
                    );
                  },
                ),
                AppSpacing.verticalMd,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.alreadyHaveAccount,
                      style: AppTypography.bodyMedium,
                    ),
                    GhostButton(
                      text: context.l10n.signIn,
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
                AppSpacing.verticalLg,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
