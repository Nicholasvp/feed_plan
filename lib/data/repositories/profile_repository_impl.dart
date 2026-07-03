import 'dart:io';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';
import '../database/app_database.dart';
import '../models/profile_model.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  @override
  Future<ProfileModel> createProfile(ProfileModel profile) async {
    try {
      final id = profile.id.isEmpty ? _uuid.v4() : profile.id;
      final now = DateTime.now();
      final entity = profile.copyWith(id: id, createdAt: now, updatedAt: now);

      await _db.into(_db.profiles).insert(ProfilesCompanion(
            id: Value(entity.id),
            name: Value(entity.name),
            bio: Value(entity.bio),
            avatarPath: Value(entity.avatarPath),
            postCount: Value(entity.postCount),
            followerCount: Value(entity.followerCount),
            followingCount: Value(entity.followingCount),
            createdAt: Value(entity.createdAt),
            updatedAt: Value(entity.updatedAt),
          ));

      return entity;
    } catch (e) {
      throw DatabaseException('Failed to create profile: $e');
    }
  }

  @override
  Future<ProfileModel?> getProfile(String id) async {
    try {
      final row = await (_db.select(_db.profiles)
            ..where((p) => p.id.equals(id)))
          .getSingleOrNull();

      if (row == null) return null;

      return ProfileModel(
        id: row.id,
        name: row.name,
        bio: row.bio,
        avatarPath: row.avatarPath,
        postCount: row.postCount,
        followerCount: row.followerCount,
        followingCount: row.followingCount,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );
    } catch (e) {
      throw DatabaseException('Failed to get profile: $e');
    }
  }

  @override
  Future<ProfileModel?> getFirstProfile() async {
    try {
      final rows = await _db.select(_db.profiles).get();
      if (rows.isEmpty) return null;
      final row = rows.first;
      return ProfileModel(
        id: row.id,
        name: row.name,
        bio: row.bio,
        avatarPath: row.avatarPath,
        postCount: row.postCount,
        followerCount: row.followerCount,
        followingCount: row.followingCount,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );
    } catch (e) {
      throw DatabaseException('Failed to get first profile: $e');
    }
  }

  @override
  Future<List<ProfileModel>> getAllProfiles() async {
    try {
      final rows = await _db.select(_db.profiles).get();

      return rows
          .map((row) => ProfileModel(
                id: row.id,
                name: row.name,
                bio: row.bio,
                avatarPath: row.avatarPath,
                postCount: row.postCount,
                followerCount: row.followerCount,
                followingCount: row.followingCount,
                createdAt: row.createdAt,
                updatedAt: row.updatedAt,
              ))
          .toList();
    } catch (e) {
      throw DatabaseException('Failed to get profiles: $e');
    }
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    try {
      final now = DateTime.now();
      final updated = profile.copyWith(updatedAt: now);

      await (_db.update(_db.profiles)
            ..where((p) => p.id.equals(profile.id)))
          .write(ProfilesCompanion(
            name: Value(updated.name),
            bio: Value(updated.bio),
            avatarPath: Value(updated.avatarPath),
            postCount: Value(updated.postCount),
            followerCount: Value(updated.followerCount),
            followingCount: Value(updated.followingCount),
            updatedAt: Value(updated.updatedAt),
          ));

      return updated;
    } catch (e) {
      throw DatabaseException('Failed to update profile: $e');
    }
  }

  @override
  Future<void> deleteProfile(String id) async {
    try {
      final rows = await (_db.select(_db.profiles)
            ..where((p) => p.id.equals(id)))
          .get();
      if (rows.isNotEmpty && rows.first.avatarPath != null) {
        _deleteFile(rows.first.avatarPath!);
      }
      await (_db.delete(_db.profiles)..where((p) => p.id.equals(id))).go();
    } catch (e) {
      throw DatabaseException('Failed to delete profile: $e');
    }
  }

  void _deleteFile(String path) {
    try {
      final file = File(path);
      if (file.existsSync()) {
        file.deleteSync();
        Logger.logInfo('Deleted file: $path', context: 'ProfileRepository');
      }
    } catch (e) {
      Logger.logError('Failed to delete file: $path', context: 'ProfileRepository');
    }
  }
}
