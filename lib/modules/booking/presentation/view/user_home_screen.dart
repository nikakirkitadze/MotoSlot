import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/locale/locale_cubit.dart';
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
  ];

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
                padding: const EdgeInsets.fromLTRB(20, 12, 8, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.l10n.appName,
                        style: AppTypography.headlineLarge,
                      ),
                    ),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return PopupMenuButton<String>(
                          offset: const Offset(0, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.borderRadiusLg,
                          ),
                          icon: Container(
                            width: 36,
                            height: 36,
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
                          onSelected: (value) {
                            if (value == 'logout') {
                              _showLogoutDialog();
                            } else if (value == 'language') {
                              context.read<LocaleCubit>().toggleLocale();
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              enabled: false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.user?.fullName ?? '',
                                    style: AppTypography.titleMedium,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    state.user?.email ?? '',
                                    style: AppTypography.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem(
                              value: 'language',
                              child: Row(
                                children: [
                                  const Icon(Icons.language_rounded, size: 20, color: AppColors.textSecondary),
                                  const SizedBox(width: 10),
                                  Text(context.l10n.language, style: AppTypography.bodyLarge),
                                  const Spacer(),
                                  Text(
                                    context.l10n.localeName == 'ka'
                                        ? context.l10n.georgian
                                        : context.l10n.english,
                                    style: AppTypography.labelMedium,
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem(
                              value: 'logout',
                              child: Row(
                                children: [
                                  const Icon(Icons.logout_rounded, size: 20, color: AppColors.error),
                                  const SizedBox(width: 10),
                                  Text(context.l10n.signOut,
                                      style: AppTypography.bodyLarge.copyWith(color: AppColors.error)),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(width: 4),
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
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusLg),
        title: Text(context.l10n.signOutConfirmTitle, style: AppTypography.headlineSmall),
        content: Text(context.l10n.signOutConfirmMessage, style: AppTypography.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthCubit>().signOut();
            },
            child: Text(context.l10n.signOut,
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
