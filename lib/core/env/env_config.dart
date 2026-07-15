import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  static String get revenueCatApiKey =>
      dotenv.env['REVENUECAT_API_KEY'] ?? '';

  static bool get hasRevenueCatKeys => revenueCatApiKey.isNotEmpty;
}
