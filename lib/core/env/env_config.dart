import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  static String get revenueCatApiKeyIos =>
      dotenv.env['REVENUECAT_API_KEY_IOS'] ?? '';

  static String get revenueCatApiKeyAndroid =>
      dotenv.env['REVENUECAT_API_KEY_ANDROID'] ?? '';

  static bool get hasRevenueCatKeys =>
      revenueCatApiKeyIos.isNotEmpty || revenueCatApiKeyAndroid.isNotEmpty;
}
