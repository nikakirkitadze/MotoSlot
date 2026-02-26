import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/app/theme.dart';
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
        appBar: AppBar(
          title: Text(context.l10n.appName),
          actions: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return PopupMenuButton<String>(
                  icon: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppTheme.primaryLight,
                    child: Text(
                      state.user?.fullName.isNotEmpty == true
                          ? state.user!.fullName[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        color: AppTheme.primaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            state.user?.email ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'language',
                      child: Row(
                        children: [
                          const Icon(Icons.language, size: 20, color: AppTheme.textSecondary),
                          const SizedBox(width: 8),
                          Text(context.l10n.language),
                          const Spacer(),
                          Text(
                            context.l10n.localeName == 'ka'
                                ? context.l10n.georgian
                                : context.l10n.english,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          const Icon(Icons.logout, size: 20, color: AppTheme.errorColor),
                          const SizedBox(width: 8),
                          Text(context.l10n.signOut,
                              style: const TextStyle(color: AppTheme.errorColor)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
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
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.signOutConfirmTitle),
        content: Text(context.l10n.signOutConfirmMessage),
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
                style: const TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}
