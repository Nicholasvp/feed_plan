import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._box);

  final Box _box;
  final _uuid = const Uuid();

  @override
  Future<ProfileModel> createProfile(ProfileModel profile) async {
    try {
      final id = profile.id.isEmpty ? _uuid.v4() : profile.id;
      final now = DateTime.now();
      final entity = profile.copyWith(id: id, createdAt: now, updatedAt: now);

      await _box.put(id, _toMap(entity));

      return entity;
    } catch (e) {
      throw DatabaseException('Failed to create profile: $e');
    }
  }

  @override
  Future<ProfileModel?> getProfile(String id) async {
    try {
      final data = _box.get(id);
      return data != null ? _fromMap(_castMap(data)) : null;
    } catch (e) {
      throw DatabaseException('Failed to get profile: $e');
    }
  }

  @override
  Future<ProfileModel?> getFirstProfile() async {
    try {
      final values = _box.values;
      return values.isNotEmpty ? _fromMap(_castMap(values.first)) : null;
    } catch (e) {
      throw DatabaseException('Failed to get first profile: $e');
    }
  }

  @override
  Future<List<ProfileModel>> getAllProfiles() async {
    try {
      return _box.values.map((data) => _fromMap(_castMap(data))).toList();
    } catch (e) {
      throw DatabaseException('Failed to get profiles: $e');
    }
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    try {
      final now = DateTime.now();
      final updated = profile.copyWith(updatedAt: now);

      await _box.put(updated.id, _toMap(updated));

      return updated;
    } catch (e) {
      throw DatabaseException('Failed to update profile: $e');
    }
  }

  @override
  Future<void> deleteProfile(String id) async {
    try {
      final data = _box.get(id);
      if (data != null) {
        final safe = _castMap(data);
        final avatarPath = safe['avatarPath'] as String?;
        if (avatarPath != null) {
          _deleteFile(avatarPath);
        }
      }
      await _box.delete(id);
    } catch (e) {
      throw DatabaseException('Failed to delete profile: $e');
    }
  }

  Map<String, dynamic> _castMap(Map data) {
    return Map<String, dynamic>.from(data);
  }

  Map<String, dynamic> _toMap(ProfileModel profile) {
    return {
      'id': profile.id,
      'name': profile.name,
      'bio': profile.bio,
      'avatarPath': profile.avatarPath,
      'postCount': profile.postCount,
      'followerCount': profile.followerCount,
      'followingCount': profile.followingCount,
      'createdAt': profile.createdAt.millisecondsSinceEpoch,
      'updatedAt': profile.updatedAt.millisecondsSinceEpoch,
    };
  }

  ProfileModel _fromMap(Map<String, dynamic> data) {
    return ProfileModel(
      id: data['id'] as String,
      name: data['name'] as String,
      bio: data['bio'] as String?,
      avatarPath: data['avatarPath'] as String?,
      postCount: data['postCount'] as int? ?? 0,
      followerCount: data['followerCount'] as int? ?? 0,
      followingCount: data['followingCount'] as int? ?? 0,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int),
      updatedAt:
          DateTime.fromMillisecondsSinceEpoch(data['updatedAt'] as int),
    );
  }

  void _deleteFile(String path) {
    try {
      final file = File(path);
      if (file.existsSync()) {
        file.deleteSync();
        Logger.logInfo('Deleted file: $path', context: 'ProfileRepository');
      }
    } catch (e) {
      Logger.logError(
          'Failed to delete file: $path', context: 'ProfileRepository');
    }
  }
}
