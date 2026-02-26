import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_slot/core/locale/locale_state.dart';
import 'package:moto_slot/core/storage/secure_storage_service.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final SecureStorageService _storageService;

  static const String _localeKey = 'app_locale';
  static const Locale _defaultLocale = Locale('ka');

  LocaleCubit({required SecureStorageService storageService})
      : _storageService = storageService,
        super(const LocaleState(locale: _defaultLocale));

  Future<void> loadSavedLocale() async {
    final savedCode = await _storageService.read(_localeKey);
    if (savedCode != null && savedCode.isNotEmpty) {
      emit(LocaleState(locale: Locale(savedCode)));
    }
  }

  Future<void> toggleLocale() async {
    final newLocale =
        state.locale.languageCode == 'ka' ? const Locale('en') : const Locale('ka');
    await _storageService.write(_localeKey, newLocale.languageCode);
    emit(LocaleState(locale: newLocale));
  }

  Future<void> setLocale(Locale locale) async {
    await _storageService.write(_localeKey, locale.languageCode);
    emit(LocaleState(locale: locale));
  }
}
