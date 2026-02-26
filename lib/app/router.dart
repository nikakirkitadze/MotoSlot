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

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    // User routes
    GoRoute(
      path: '/home',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<UserSlotsCubit>()),
          BlocProvider(create: (_) => getIt<BookingCubit>()),
        ],
        child: const UserHomeScreen(),
      ),
    ),
    GoRoute(
      path: '/slot-details',
      builder: (context, state) {
        final slot = state.extra as TimeSlot;
        return BlocProvider(
          create: (_) => getIt<BookingCubit>(),
          child: SlotDetailsScreen(slot: slot),
        );
      },
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) {
        final booking = state.extra as Booking;
        return BlocProvider(
          create: (_) => getIt<BookingCubit>(),
          child: PaymentScreen(booking: booking),
        );
      },
    ),
    GoRoute(
      path: '/payment-webview',
      builder: (context, state) {
        final params = state.extra as Map<String, String>;
        return PaymentWebViewScreen(
          paymentUrl: params['paymentUrl']!,
          paymentId: params['paymentId']!,
        );
      },
    ),
    GoRoute(
      path: '/booking-confirmation',
      builder: (context, state) {
        final booking = state.extra as Booking;
        return BookingConfirmationScreen(booking: booking);
      },
    ),
    GoRoute(
      path: '/booking-details',
      builder: (context, state) {
        final booking = state.extra as Booking;
        return BlocProvider(
          create: (_) => getIt<BookingCubit>(),
          child: BookingDetailsScreen(booking: booking),
        );
      },
    ),
    // Admin routes
    GoRoute(
      path: '/admin',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<AdminAvailabilityCubit>()),
          BlocProvider(create: (_) => getIt<AdminBookingsCubit>()),
        ],
        child: const AdminHomeScreen(),
      ),
    ),
    GoRoute(
      path: '/admin/manual-booking',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<AdminBookingsCubit>()),
          BlocProvider(create: (_) => getIt<AdminAvailabilityCubit>()..loadConfig()),
        ],
        child: const AdminManualBookingScreen(),
      ),
    ),
    GoRoute(
      path: '/admin/booking-detail',
      builder: (context, state) {
        final booking = state.extra as Booking;
        return BlocProvider(
          create: (_) => getIt<AdminBookingsCubit>(),
          child: AdminBookingDetailScreen(booking: booking),
        );
      },
    ),
  ],
);
