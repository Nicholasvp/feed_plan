import 'package:flutter_bloc/flutter_bloc.dart';

import 'locale_event.dart';
import 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(const LocaleState(LocaleState.defaultLocale)) {
    on<ChangeLocale>(_onChangeLocale);
  }

  Future<void> _onChangeLocale(
    ChangeLocale event,
    Emitter<LocaleState> emit,
  ) async {
    emit(LocaleState(event.locale));
  }
}
