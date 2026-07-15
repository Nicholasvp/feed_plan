import 'package:hive_flutter/hive_flutter.dart';

import '../models/instagram_post_model.dart';
import '../../core/utils/logger.dart';

class InstagramCacheService {
  InstagramCacheService._();

  static final InstagramCacheService instance = InstagramCacheService._();

  static const String _postsKey = 'posts';
  static const String _lastRequestKey = 'last_request_time';
  static const String _usernameKey = 'username';

  Box? _box;

  Future<void> initialize() async {
    _box = await Hive.openBox('instagram_posts');
    Logger.logInfo('InstagramCacheService initialized', context: 'InstagramCacheService');
  }

  Box get _ensureBox {
    if (_box == null) {
      throw StateError('InstagramCacheService not initialized. Call initialize() first.');
    }
    return _box!;
  }

  Future<List<InstagramPostModel>> getCachedPosts() async {
    try {
      final box = _ensureBox;
      final data = box.get(_postsKey);
      if (data == null) return [];

      final List<dynamic> postsList = data as List<dynamic>;
      return postsList
          .map((item) => InstagramPostModel.fromMap(Map<String, dynamic>.from(item)))
          .toList();
    } catch (e) {
      Logger.logError('Failed to get cached posts: $e', context: 'InstagramCacheService');
      return [];
    }
  }

  Future<String?> getCachedUsername() async {
    try {
      final box = _ensureBox;
      return box.get(_usernameKey) as String?;
    } catch (e) {
      return null;
    }
  }

  Future<void> savePosts(String username, List<InstagramPostModel> posts) async {
    try {
      final box = _ensureBox;
      final postsData = posts.map((p) => p.toMap()).toList();
      await box.put(_postsKey, postsData);
      await box.put(_usernameKey, username);
      Logger.logInfo(
        'Saved ${posts.length} posts for @$username',
        context: 'InstagramCacheService',
      );
    } catch (e) {
      Logger.logError('Failed to save posts: $e', context: 'InstagramCacheService');
    }
  }

  Future<bool> canRequest() async {
    try {
      final box = _ensureBox;
      final lastRequest = box.get(_lastRequestKey);

      if (lastRequest == null) return true;

      final lastTime = DateTime.fromMillisecondsSinceEpoch(lastRequest as int);
      final now = DateTime.now();
      final difference = now.difference(lastTime);

      return difference.inHours >= 24;
    } catch (e) {
      return true;
    }
  }

  Future<DateTime?> getLastRequestTime() async {
    try {
      final box = _ensureBox;
      final lastRequest = box.get(_lastRequestKey);
      if (lastRequest == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(lastRequest as int);
    } catch (e) {
      return null;
    }
  }

  Future<void> markRequested() async {
    try {
      final box = _ensureBox;
      await box.put(_lastRequestKey, DateTime.now().millisecondsSinceEpoch);
      Logger.logInfo('Marked request time', context: 'InstagramCacheService');
    } catch (e) {
      Logger.logError('Failed to mark request: $e', context: 'InstagramCacheService');
    }
  }

  Future<int> getRequestsToday() async {
    try {
      final box = _ensureBox;
      final lastRequest = box.get(_lastRequestKey);

      if (lastRequest == null) return 0;

      final lastTime = DateTime.fromMillisecondsSinceEpoch(lastRequest as int);
      final now = DateTime.now();

      if (lastTime.year == now.year &&
          lastTime.month == now.month &&
          lastTime.day == now.day) {
        return 1;
      }

      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<void> clearCache() async {
    try {
      final box = _ensureBox;
      await box.clear();
      Logger.logInfo('Cache cleared', context: 'InstagramCacheService');
    } catch (e) {
      Logger.logError('Failed to clear cache: $e', context: 'InstagramCacheService');
    }
  }
}
