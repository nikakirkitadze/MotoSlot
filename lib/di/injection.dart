import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:moto_slot/core/network/api_client.dart';
import 'package:moto_slot/core/storage/secure_storage_service.dart';
import 'package:moto_slot/modules/auth/data/repository/auth_repository.dart';
import 'package:moto_slot/modules/booking/data/repository/booking_repository.dart';
import 'package:moto_slot/modules/booking/data/repository/slot_repository.dart';
import 'package:moto_slot/modules/payments/data/repository/payment_repository.dart';
import 'package:moto_slot/modules/notifications/data/repository/notification_repository.dart';
import 'package:moto_slot/modules/admin/data/repository/admin_repository.dart';

import 'package:moto_slot/modules/auth/presentation/cubit/auth_cubit.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/user_slots_cubit.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/booking_cubit.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_availability_cubit.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_bookings_cubit.dart';
import 'package:moto_slot/modules/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:moto_slot/modules/payments/presentation/cubit/payment_cubit.dart';
import 'package:moto_slot/core/locale/locale_cubit.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // External
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseFunctions>(() => FirebaseFunctions.instance);
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Core Services
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(storage: getIt<FlutterSecureStorage>()),
  );
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: 'https://us-central1-a-eye-8c9a7.cloudfunctions.net',
      storage: getIt<FlutterSecureStorage>(),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
      storageService: getIt<SecureStorageService>(),
    ),
  );
  getIt.registerLazySingleton<SlotRepository>(
    () => SlotRepository(firestore: getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<BookingRepository>(
    () => BookingRepository(
      firestore: getIt<FirebaseFirestore>(),
      functions: getIt<FirebaseFunctions>(),
    ),
  );
  getIt.registerLazySingleton<PaymentRepository>(
    () => PaymentRepository(
      functions: getIt<FirebaseFunctions>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepository(),
  );
  getIt.registerLazySingleton<AdminRepository>(
    () => AdminRepository(
      firestore: getIt<FirebaseFirestore>(),
      functions: getIt<FirebaseFunctions>(),
    ),
  );

  // Locale
  getIt.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(storageService: getIt<SecureStorageService>()),
  );

  // Cubits
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerFactory<UserSlotsCubit>(
    () => UserSlotsCubit(slotRepository: getIt<SlotRepository>()),
  );
  getIt.registerFactory<BookingCubit>(
    () => BookingCubit(
      bookingRepository: getIt<BookingRepository>(),
      paymentRepository: getIt<PaymentRepository>(),
    ),
  );
  getIt.registerFactory<AdminAvailabilityCubit>(
    () => AdminAvailabilityCubit(adminRepository: getIt<AdminRepository>()),
  );
  getIt.registerFactory<AdminBookingsCubit>(
    () => AdminBookingsCubit(adminRepository: getIt<AdminRepository>()),
  );
  getIt.registerLazySingleton<NotificationsCubit>(
    () => NotificationsCubit(
      notificationRepository: getIt<NotificationRepository>(),
    ),
  );
  getIt.registerFactory<PaymentCubit>(
    () => PaymentCubit(paymentRepository: getIt<PaymentRepository>()),
  );
}
