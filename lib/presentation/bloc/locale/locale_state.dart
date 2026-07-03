import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LocaleState extends Equatable {
  const LocaleState(this.locale);

  final Locale locale;

  static const Locale defaultLocale = Locale('pt');

  @override
  List<Object?> get props => [locale];
}
