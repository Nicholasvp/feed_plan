import 'package:equatable/equatable.dart';
import '../../domain/entities/profile.dart';

class ProfileModel extends Equatable {
  const ProfileModel({
    required this.id,
    required this.name,
    this.bio,
    this.avatarPath,
    this.instagramUsername,
    this.postCount = 0,
    this.followerCount = 0,
    this.followingCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String? bio;
  final String? avatarPath;
  final String? instagramUsername;
  final int postCount;
  final int followerCount;
  final int followingCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      id: profile.id,
      name: profile.name,
      bio: profile.bio,
      avatarPath: profile.avatarPath,
      instagramUsername: profile.instagramUsername,
      postCount: profile.postCount,
      followerCount: profile.followerCount,
      followingCount: profile.followingCount,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
  }

  Profile toEntity() {
    return Profile(
      id: id,
      name: name,
      bio: bio,
      avatarPath: avatarPath,
      instagramUsername: instagramUsername,
      postCount: postCount,
      followerCount: followerCount,
      followingCount: followingCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  ProfileModel copyWith({
    String? id,
    String? name,
    String? bio,
    String? avatarPath,
    String? instagramUsername,
    int? postCount,
    int? followerCount,
    int? followingCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatarPath: avatarPath ?? this.avatarPath,
      instagramUsername: instagramUsername ?? this.instagramUsername,
      postCount: postCount ?? this.postCount,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        bio,
        avatarPath,
        instagramUsername,
        postCount,
        followerCount,
        followingCount,
        createdAt,
        updatedAt,
      ];
}
