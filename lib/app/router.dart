import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:moto_slot/di/injection.dart';
import 'package:moto_slot/modules/auth/presentation/view/splash_screen.dart';
import 'package:moto_slot/modules/auth/presentation/view/login_screen.dart';
import 'package:moto_slot/modules/auth/presentation/view/register_screen.dart';
import 'package:moto_slot/modules/auth/presentation/view/forgot_password_screen.dart';
import 'package:moto_slot/modules/booking/presentation/view/user_home_screen.dart';
import 'package:moto_slot/modules/booking/presentation/view/slot_details_screen.dart';
import 'package:moto_slot/modules/booking/presentation/view/booking_confirmation_screen.dart';
import 'package:moto_slot/modules/booking/presentation/view/booking_details_screen.dart';
import 'package:moto_slot/modules/payments/presentation/view/payment_screen.dart';
import 'package:moto_slot/modules/payments/presentation/view/payment_webview_screen.dart';
import 'package:moto_slot/modules/admin/presentation/view/admin_home_screen.dart';
import 'package:moto_slot/modules/admin/presentation/view/admin_manual_booking_screen.dart';
import 'package:moto_slot/modules/admin/presentation/view/admin_booking_detail_screen.dart';
import 'package:moto_slot/modules/booking/domain/model/time_slot.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/booking_cubit.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/user_slots_cubit.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_availability_cubit.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_bookings_cubit.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

Page<void> _buildPage(Widget child, GoRouterState state) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => _buildPage(const SplashScreen(), state),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => _buildPage(const LoginScreen(), state),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) => _buildPage(const RegisterScreen(), state),
    ),
    GoRoute(
      path: '/forgot-password',
      pageBuilder: (context, state) => _buildPage(const ForgotPasswordScreen(), state),
    ),
    // User routes
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => _buildPage(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<UserSlotsCubit>()),
            BlocProvider(create: (_) => getIt<BookingCubit>()),
          ],
          child: const UserHomeScreen(),
        ),
        state,
      ),
    ),
    GoRoute(
      path: '/slot-details',
      pageBuilder: (context, state) {
        final slot = state.extra as TimeSlot;
        return _buildPage(
          BlocProvider(
            create: (_) => getIt<BookingCubit>(),
            child: SlotDetailsScreen(slot: slot),
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: '/payment',
      pageBuilder: (context, state) {
        final booking = state.extra as Booking;
        return _buildPage(
          BlocProvider(
            create: (_) => getIt<BookingCubit>(),
            child: PaymentScreen(booking: booking),
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: '/payment-webview',
      pageBuilder: (context, state) {
        final params = state.extra as Map<String, String>;
        return _buildPage(
          PaymentWebViewScreen(
            paymentUrl: params['paymentUrl']!,
            paymentId: params['paymentId']!,
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: '/booking-confirmation',
      pageBuilder: (context, state) {
        final booking = state.extra as Booking;
        return _buildPage(BookingConfirmationScreen(booking: booking), state);
      },
    ),
    GoRoute(
      path: '/booking-details',
      pageBuilder: (context, state) {
        final booking = state.extra as Booking;
        return _buildPage(
          BlocProvider(
            create: (_) => getIt<BookingCubit>(),
            child: BookingDetailsScreen(booking: booking),
          ),
          state,
        );
      },
    ),
    // Admin routes
    GoRoute(
      path: '/admin',
      pageBuilder: (context, state) => _buildPage(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<AdminAvailabilityCubit>()),
            BlocProvider(create: (_) => getIt<AdminBookingsCubit>()),
          ],
          child: const AdminHomeScreen(),
        ),
        state,
      ),
    ),
    GoRoute(
      path: '/admin/manual-booking',
      pageBuilder: (context, state) => _buildPage(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<AdminBookingsCubit>()),
            BlocProvider(create: (_) => getIt<AdminAvailabilityCubit>()..loadConfig()),
          ],
          child: const AdminManualBookingScreen(),
        ),
        state,
      ),
    ),
    GoRoute(
      path: '/admin/booking-detail',
      pageBuilder: (context, state) {
        final booking = state.extra as Booking;
        return _buildPage(
          BlocProvider(
            create: (_) => getIt<AdminBookingsCubit>(),
            child: AdminBookingDetailScreen(booking: booking),
          ),
          state,
        );
      },
    ),
  ],
);
