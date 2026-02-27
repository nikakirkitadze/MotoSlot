import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/widgets/widgets.dart';
import 'package:moto_slot/modules/auth/presentation/cubit/auth_cubit.dart';
import 'package:moto_slot/modules/auth/presentation/cubit/auth_state.dart';
import 'package:moto_slot/modules/admin/presentation/view/admin_calendar_screen.dart';
import 'package:moto_slot/modules/admin/presentation/view/admin_bookings_screen.dart';
import 'package:moto_slot/modules/admin/presentation/view/admin_settings_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;

  final _screens = const [
    AdminCalendarScreen(),
    AdminBookingsScreen(),
    AdminSettingsScreen(),
  ];

  String _headerTitle(BuildContext context) {
    return switch (_currentIndex) {
      0 => context.l10n.dashboard,
      1 => context.l10n.bookings,
      2 => context.l10n.settings,
      _ => context.l10n.admin,
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
        body: Column(
          children: [
            // Navy gradient header
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.navyGradient,
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 12, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _headerTitle(context),
                          style: AppTypography.headlineLarge.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () => AppSignOutDialog.showAsDialog(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  state.user?.fullName.isNotEmpty == true
                                      ? state.user!.fullName[0].toUpperCase()
                                      : 'A',
                                  style: AppTypography.titleMedium.copyWith(
                                    color: AppColors.textOnPrimary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: _screens[_currentIndex]),
          ],
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
                icon: const Icon(Icons.dashboard_outlined),
                activeIcon: const Icon(Icons.dashboard),
                label: context.l10n.dashboard,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.book_outlined),
                activeIcon: const Icon(Icons.book),
                label: context.l10n.bookings,
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
