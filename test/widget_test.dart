import 'package:flutter_test/flutter_test.dart';

import 'package:feed_plan/core/constants/aspect_ratios.dart';
import 'package:feed_plan/core/enums/media_type.dart';
import 'package:feed_plan/domain/entities/carousel.dart';
import 'package:feed_plan/domain/entities/profile.dart';

void main() {
  group('Domain entities', () {
    test('Profile should support value equality', () {
      final now = DateTime.now();
      final a = Profile(
        id: '1',
        name: 'Test',
        bio: 'Bio',
        createdAt: now,
        updatedAt: now,
      );
      final b = Profile(
        id: '1',
        name: 'Test',
        bio: 'Bio',
        createdAt: now,
        updatedAt: now,
      );
      expect(a, equals(b));
    });

    test('Profile should support copyWith', () {
      final now = DateTime.now();
      final p = Profile(
        id: '1',
        name: 'Old',
        bio: 'Bio',
        createdAt: now,
        updatedAt: now,
      );
      final updated = p.copyWith(name: 'New');
      expect(updated.name, 'New');
      expect(updated.id, '1');
    });

    test('Carousel and MediaItem should work', () {
      final now = DateTime.now();
      final carousel = Carousel(
        id: 'c1',
        profileId: 'p1',
        order: 1,
        aspectRatio: '1:1',
        createdAt: now,
        updatedAt: now,
      );
      expect(carousel.aspectRatio, '1:1');
      expect(carousel.profileId, 'p1');
    });
  });

  group('Core utilities', () {
    test('AspectRatioPreset should return correct values', () {
      expect(AspectRatioPreset.square.value, '1:1');
      expect(AspectRatioPreset.portrait.value, '4:5');
      expect(AspectRatioPreset.fromValue('4:5'), AspectRatioPreset.portrait);
    });

    test('MediaType enum should work', () {
      expect(MediaType.image.isImage, true);
      expect(MediaType.video.isVideo, true);
      expect(MediaType.fromString('video'), MediaType.video);
    });
  });
}
