import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/locale/locale_cubit.dart';
import 'package:moto_slot/core/widgets/widgets.dart';
import 'package:moto_slot/modules/auth/presentation/cubit/auth_cubit.dart';
import 'package:moto_slot/modules/auth/presentation/cubit/auth_state.dart';
import 'package:moto_slot/modules/booking/presentation/view/user_calendar_screen.dart';
import 'package:moto_slot/modules/booking/presentation/view/my_bookings_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _currentIndex = 0;

  final _screens = const [
    UserCalendarScreen(),
    MyBookingsScreen(),
    _UserSettingsTab(),
  ];

  String _headerTitle(BuildContext context) {
    return switch (_currentIndex) {
      0 => context.l10n.scheduleLesson,
      1 => context.l10n.myBookings,
      2 => context.l10n.settings,
      _ => context.l10n.appName,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (!state.isAuthenticated) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Custom header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _headerTitle(context),
                        style: AppTypography.headlineLarge.copyWith(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () => setState(() => _currentIndex = 2),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                state.user?.fullName.isNotEmpty == true
                                    ? state.user!.fullName[0].toUpperCase()
                                    : 'U',
                                style: AppTypography.titleMedium.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              Expanded(child: _screens[_currentIndex]),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: const Border(top: BorderSide(color: AppColors.border, width: 1)),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textHint,
            selectedLabelStyle: AppTypography.labelMedium.copyWith(color: AppColors.primary),
            unselectedLabelStyle: AppTypography.labelMedium,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_month_outlined),
                activeIcon: const Icon(Icons.calendar_month),
                label: context.l10n.book,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.receipt_long_outlined),
                activeIcon: const Icon(Icons.receipt_long),
                label: context.l10n.myBookings,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings_outlined),
                activeIcon: const Icon(Icons.settings),
                label: context.l10n.settings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserSettingsTab extends StatelessWidget {
  const _UserSettingsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSpacing.verticalMd,
          // Language toggle
          AppCard(
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: AppRadius.borderRadiusSm,
                  ),
                  child: const Icon(Icons.language_rounded, size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(context.l10n.language, style: AppTypography.titleMedium),
                ),
                GestureDetector(
                  onTap: () => context.read<LocaleCubit>().toggleLocale(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: AppRadius.borderRadiusFull,
                    ),
                    child: Text(
                      context.l10n.localeName == 'ka'
                          ? context.l10n.georgian
                          : context.l10n.english,
                      style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.verticalMd,
          // Sign out
          AppCard(
            onTap: () => AppSignOutDialog.showAsBottomSheet(context),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: AppRadius.borderRadiusSm,
                  ),
                  child: const Icon(Icons.logout_rounded, size: 18, color: AppColors.error),
                ),
                const SizedBox(width: 12),
                Text(
                  context.l10n.signOut,
                  style: AppTypography.titleMedium.copyWith(color: AppColors.error),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
