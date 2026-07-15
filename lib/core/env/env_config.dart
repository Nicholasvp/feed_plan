import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  // RevenueCat
  static String get revenueCatApiKey =>
      dotenv.env['REVENUECAT_API_KEY'] ?? '';

  static bool get hasRevenueCatKeys => revenueCatApiKey.isNotEmpty;

  // Apify
  static String get apifyApiToken =>
      dotenv.env['APIFY_API_TOKEN'] ?? '';

  static bool get hasApifyToken => apifyApiToken.isNotEmpty;

  static String get apifyInstagramActorId =>
      dotenv.env['APIFY_INSTAGRAM_ACTOR_ID'] ?? 'nH2AHrwxeTRJoN5hX';
}
