import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moto_slot/l10n/generated/app_localizations.dart';

import 'package:moto_slot/firebase_options.dart';
import 'package:moto_slot/app/theme.dart';
import 'package:moto_slot/app/router.dart';
import 'package:moto_slot/di/injection.dart';
import 'package:moto_slot/core/locale/locale_cubit.dart';
import 'package:moto_slot/core/locale/locale_state.dart';
import 'package:moto_slot/modules/auth/presentation/cubit/auth_cubit.dart';
import 'package:moto_slot/modules/notifications/presentation/cubit/notifications_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configure DI
  await configureDependencies();

  // Load saved locale
  await getIt<LocaleCubit>().loadSavedLocale();

  // Initialize notifications
  await getIt<NotificationsCubit>().initialize();

  runApp(const MotoSlotApp());
}

class MotoSlotApp extends StatelessWidget {
  const MotoSlotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => getIt<AuthCubit>(),
        ),
        BlocProvider<NotificationsCubit>(
          create: (_) => getIt<NotificationsCubit>(),
        ),
        BlocProvider<LocaleCubit>(
          create: (_) => getIt<LocaleCubit>(),
        ),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return MaterialApp.router(
            title: 'MotoSlot',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: appRouter,
            locale: localeState.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
