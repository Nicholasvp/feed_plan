import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  Size get mediaQuerySize => MediaQuery.sizeOf(this);
  double get screenWidth => mediaQuerySize.width;
  double get screenHeight => mediaQuerySize.height;
}
