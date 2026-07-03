import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object?> get props => [];
}

class ChangeLocale extends LocaleEvent {
  const ChangeLocale(this.locale);

  final Locale locale;

  @override
  List<Object?> get props => [locale];
}
