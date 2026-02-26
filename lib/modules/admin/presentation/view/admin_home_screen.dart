import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/app/theme.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
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
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  context.l10n.admin,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(context.l10n.appName),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _showLogoutDialog(),
            ),
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
              label: context.l10n.calendar,
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
