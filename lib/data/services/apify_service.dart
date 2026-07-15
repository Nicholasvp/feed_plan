import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/env/env_config.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';
import '../models/instagram_post_model.dart';
import '../models/instagram_profile_model.dart';

class ApifyService {
  ApifyService._();

  static final ApifyService instance = ApifyService._();

  static const String _baseUrl = 'https://api.apify.com/v2';

  Future<List<InstagramPostModel>> getInstagramPosts({
    required String username,
    int resultsLimit = 20,
    bool skipPinnedPosts = false,
    String dataDetailLevel = 'basicData',
  }) async {
    Logger.logInfo(
      'Starting getInstagramPosts',
      context: 'ApifyService',
    );

    if (!EnvConfig.hasApifyToken) {
      Logger.logError(
        'Apify token not configured',
        context: 'ApifyService',
      );
      throw const ServerException(message: 'Apify token not configured');
    }

    final cleanUsernameResult = cleanUsername(username);

    final url = Uri.parse(
      '$_baseUrl/acts/${EnvConfig.apifyInstagramActorId}/run-sync-get-dataset-items',
    );

    final body = {
      'username': [cleanUsernameResult],
      'resultsLimit': resultsLimit,
      'skipPinnedPosts': skipPinnedPosts,
      'dataDetailLevel': dataDetailLevel,
    };

    Logger.logInfo('Username: $cleanUsernameResult', context: 'ApifyService');
    Logger.logInfo('Actor ID: ${EnvConfig.apifyInstagramActorId}', context: 'ApifyService');
    Logger.logInfo('URL: $url', context: 'ApifyService');
    Logger.logInfo('Request body: ${jsonEncode(body)}', context: 'ApifyService');

    try {
      Logger.logInfo('Sending HTTP POST...', context: 'ApifyService');

      final response = await http
          .post(
            url,
            headers: {
              'Authorization': 'Bearer ${EnvConfig.apifyApiToken}',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 120));

      Logger.logInfo(
        'Response received - Status: ${response.statusCode}',
        context: 'ApifyService',
      );
      Logger.logInfo(
        'Response body length: ${response.body.length} chars',
        context: 'ApifyService',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = jsonDecode(response.body);
        Logger.logInfo(
          'Parsed ${data.length} posts successfully',
          context: 'ApifyService',
        );

        if (data.isNotEmpty) {
          Logger.logInfo(
            'First post keys: ${(data.first as Map).keys.join(', ')}',
            context: 'ApifyService',
          );
        }

        return data
            .map((item) => InstagramPostModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      Logger.logError(
        'Apify API error: ${response.statusCode}',
        context: 'ApifyService',
      );
      Logger.logError(
        'Response body: ${response.body}',
        context: 'ApifyService',
      );

      throw ServerException(
        message: 'Failed to fetch Instagram posts: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } catch (e, stackTrace) {
      Logger.logError(
        'Exception in getInstagramPosts: $e',
        context: 'ApifyService',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  String cleanUsername(String input) {
    var cleaned = input.trim();

    cleaned = cleaned.replaceAll(RegExp(r'^@+'), '');

    cleaned = cleaned.replaceAll(RegExp(r'^https?://(www\.)?instagram\.com/'), '');

    cleaned = cleaned.replaceAll(RegExp(r'/+$'), '');

    cleaned = cleaned.replaceAll(RegExp(r'^p/.*'), '');

    return cleaned;
  }

  static const String _profileActorId = 'dSCLg0C3YEZ83HzYX';

  Future<InstagramProfileModel> getInstagramProfile({
    required String username,
  }) async {
    Logger.logInfo(
      'Starting getInstagramProfile',
      context: 'ApifyService',
    );

    if (!EnvConfig.hasApifyToken) {
      Logger.logError(
        'Apify token not configured',
        context: 'ApifyService',
      );
      throw const ServerException(message: 'Apify token not configured');
    }

    final cleanUsernameResult = cleanUsername(username);

    final url = Uri.parse(
      '$_baseUrl/acts/$_profileActorId/run-sync-get-dataset-items',
    );

    final body = {
      'usernames': [cleanUsernameResult],
      'includeAboutSection': false,
    };

    Logger.logInfo('Profile fetch - Username: $cleanUsernameResult', context: 'ApifyService');
    Logger.logInfo('URL: $url', context: 'ApifyService');

    try {
      Logger.logInfo('Sending HTTP POST for profile...', context: 'ApifyService');

      final response = await http
          .post(
            url,
            headers: {
              'Authorization': 'Bearer ${EnvConfig.apifyApiToken}',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 120));

      Logger.logInfo(
        'Profile response - Status: ${response.statusCode}',
        context: 'ApifyService',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          final profileData = data.first as Map<String, dynamic>;
          Logger.logInfo(
            'Profile parsed: ${profileData['fullName']}',
            context: 'ApifyService',
          );
          return InstagramProfileModel.fromJson(profileData);
        }

        throw const ServerException(
          message: 'No profile data returned from Instagram',
        );
      }

      Logger.logError(
        'Apify profile API error: ${response.statusCode}',
        context: 'ApifyService',
      );

      throw ServerException(
        message: 'Failed to fetch Instagram profile: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } catch (e, stackTrace) {
      Logger.logError(
        'Exception in getInstagramProfile: $e',
        context: 'ApifyService',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
