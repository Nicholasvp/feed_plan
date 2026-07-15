import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/database/hive_service.dart';
import 'locale_event.dart';
import 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(const LocaleState(LocaleState.defaultLocale)) {
    on<LoadLocale>(_onLoadLocale);
    on<ChangeLocale>(_onChangeLocale);
    add(const LoadLocale());
  }

  Future<void> _onLoadLocale(
    LoadLocale event,
    Emitter<LocaleState> emit,
  ) async {
    final box = await HiveService.openPreferencesBox();
    final savedLanguageCode = box.get('locale', defaultValue: 'en');
    emit(LocaleState(Locale(savedLanguageCode)));
  }

  Future<void> _onChangeLocale(
    ChangeLocale event,
    Emitter<LocaleState> emit,
  ) async {
    final box = await HiveService.openPreferencesBox();
    await box.put('locale', event.locale.languageCode);
    emit(LocaleState(event.locale));
  }
}
