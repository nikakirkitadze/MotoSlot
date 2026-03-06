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

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onComplete() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().completeProfile(
            fullName: _nameController.text,
            phone: _phoneController.text.isEmpty
                ? null
                : _phoneController.text,
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
        if (state.isAuthenticated && !state.needsProfileCompletion) {
          if (state.isAdmin) {
            context.go('/admin');
          } else {
            context.go('/home');
          }
        }
      },
      child: AppScaffold(
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
                    child: AppLogo(
                      variant: AppLogoVariant.iconWithMS,
                      iconSize: 48,
                    ),
                  ),
                ),
                AppSpacing.verticalLg,
                FadeInWidget(
                  delay: const Duration(milliseconds: 100),
                  child: Text(
                    context.l10n.completeYourProfile,
                    style: AppTypography.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                AppSpacing.verticalSm,
                FadeInWidget(
                  delay: const Duration(milliseconds: 150),
                  child: Text(
                    context.l10n.completeProfileSubtitle,
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                AppSpacing.verticalXl,
                StaggeredItem(
                  index: 0,
                  child: AppTextField(
                    label: context.l10n.fullName,
                    hint: context.l10n.fullNameHint,
                    controller: _nameController,
                    validator: Validators.nameValidator(context),
                    prefixIcon:
                        const Icon(Icons.person_outline_rounded, size: 20),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                AppSpacing.verticalMd,
                StaggeredItem(
                  index: 1,
                  child: AppTextField(
                    label:
                        '${context.l10n.phoneNumber} (${context.l10n.optional})',
                    hint: context.l10n.phoneHint,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _onComplete(),
                  ),
                ),
                AppSpacing.verticalLg,
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return NavyButton(
                      text: context.l10n.continueText,
                      onPressed: _onComplete,
                      isLoading: state.isLoading,
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
}
