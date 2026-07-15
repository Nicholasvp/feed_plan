import 'package:feed_plan/data/models/instagram_post_model.dart';
import 'package:feed_plan/data/services/apify_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ApifyService service;

  setUp(() {
    service = ApifyService.instance;
  });

  group('InstagramPostModel.fromJson', () {
    final mockJsonResponse = [
      {
        'id': '3940488089406305462',
        'shortCode': 'DavbQoquHS2',
        'displayUrl': 'https://example.com/image.jpg',
        'caption': 'Test caption',
        'likesCount': 745,
        'commentsCount': 144,
        'timestamp': '2026-07-13T17:16:05.000Z',
        'ownerUsername': 'testuser',
        'type': 'Video',
        'url': 'https://www.instagram.com/p/DavbQoquHS2/',
        'videoUrl': 'https://example.com/video.mp4',
      },
      {
        'id': '3933087964510444155',
        'shortCode': 'DaVIqpTAlp7',
        'displayUrl': 'https://example.com/image2.jpg',
        'caption': 'Another caption',
        'likesCount': 133,
        'commentsCount': 3,
        'timestamp': '2026-07-03T12:10:43.000Z',
        'ownerUsername': 'otheruser',
        'type': 'Sidecar',
        'url': 'https://www.instagram.com/p/DaVIqpTAlp7/',
      },
    ];

    test('should parse complete JSON correctly', () {
      final posts = mockJsonResponse
          .map((item) => InstagramPostModel.fromJson(item))
          .toList();

      expect(posts.length, equals(2));

      // First post (Video)
      expect(posts[0].id, equals('3940488089406305462'));
      expect(posts[0].shortCode, equals('DavbQoquHS2'));
      expect(posts[0].displayUrl, equals('https://example.com/image.jpg'));
      expect(posts[0].caption, equals('Test caption'));
      expect(posts[0].likesCount, equals(745));
      expect(posts[0].commentsCount, equals(144));
      expect(posts[0].ownerUsername, equals('testuser'));
      expect(posts[0].type, equals('Video'));
      expect(posts[0].isVideo, isTrue);
      expect(posts[0].isSidecar, isFalse);
      expect(posts[0].postUrl, equals('https://www.instagram.com/p/DavbQoquHS2/'));
      expect(posts[0].videoUrl, equals('https://example.com/video.mp4'));

      // Second post (Sidecar)
      expect(posts[1].id, equals('3933087964510444155'));
      expect(posts[1].shortCode, equals('DaVIqpTAlp7'));
      expect(posts[1].isVideo, isFalse);
      expect(posts[1].isSidecar, isTrue);
    });

    test('should parse Sidecar type correctly', () {
      final sidecarJson = {
        'id': '123',
        'shortCode': 'abc',
        'displayUrl': 'https://example.com/image.jpg',
        'type': 'Sidecar',
        'likesCount': 10,
        'commentsCount': 2,
        'ownerUsername': 'user',
        'url': 'https://www.instagram.com/p/abc/',
      };

      final post = InstagramPostModel.fromJson(sidecarJson);

      expect(post.isVideo, isFalse);
      expect(post.isSidecar, isTrue);
      expect(post.type, equals('Sidecar'));
    });

    test('should parse Image type correctly', () {
      final imageJson = {
        'id': '456',
        'shortCode': 'def',
        'displayUrl': 'https://example.com/image.jpg',
        'type': 'Image',
        'likesCount': 50,
        'commentsCount': 5,
        'ownerUsername': 'user2',
        'url': 'https://www.instagram.com/p/def/',
      };

      final post = InstagramPostModel.fromJson(imageJson);

      expect(post.isVideo, isFalse);
      expect(post.isSidecar, isFalse);
      expect(post.type, equals('Image'));
    });

    test('should handle missing optional fields', () {
      final minimalJson = {
        'id': '789',
        'shortCode': 'ghi',
        'displayUrl': 'https://example.com/image.jpg',
      };

      final post = InstagramPostModel.fromJson(minimalJson);

      expect(post.id, equals('789'));
      expect(post.shortCode, equals('ghi'));
      expect(post.displayUrl, equals('https://example.com/image.jpg'));
      expect(post.caption, isNull);
      expect(post.likesCount, equals(0));
      expect(post.commentsCount, equals(0));
      expect(post.timestamp, isNull);
      expect(post.ownerUsername, equals(''));
      expect(post.type, equals('Image'));
      expect(post.videoUrl, isNull);
      expect(post.postUrl, equals(''));
    });
  });

  group('ApifyService.cleanUsername', () {
    test('should remove @ prefix', () {
      expect(service.cleanUsername('@natgeo'), equals('natgeo'));
    });

    test('should remove multiple @ prefixes', () {
      expect(service.cleanUsername('@@natgeo'), equals('natgeo'));
    });

    test('should remove Instagram URL prefix', () {
      expect(
        service.cleanUsername('https://www.instagram.com/natgeo/'),
        equals('natgeo'),
      );
    });

    test('should remove HTTP URL prefix', () {
      expect(
        service.cleanUsername('http://instagram.com/natgeo'),
        equals('natgeo'),
      );
    });

    test('should handle URL without www', () {
      expect(
        service.cleanUsername('https://instagram.com/natgeo/'),
        equals('natgeo'),
      );
    });

    test('should trim whitespace', () {
      expect(service.cleanUsername('  natgeo  '), equals('natgeo'));
    });

    test('should handle combined @ and URL', () {
      expect(
        service.cleanUsername('@https://www.instagram.com/natgeo/'),
        equals('natgeo'),
      );
    });
  });
}
