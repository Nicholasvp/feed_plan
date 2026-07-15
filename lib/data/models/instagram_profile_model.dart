import 'package:equatable/equatable.dart';

class InstagramProfileModel extends Equatable {
  const InstagramProfileModel({
    required this.username,
    required this.fullName,
    this.profilePicUrl,
    this.biography,
    this.postsCount = 0,
    this.followersCount = 0,
    this.followsCount = 0,
    this.isPrivate = false,
    this.isVerified = false,
    this.isBusinessAccount = false,
  });

  final String username;
  final String fullName;
  final String? profilePicUrl;
  final String? biography;
  final int postsCount;
  final int followersCount;
  final int followsCount;
  final bool isPrivate;
  final bool isVerified;
  final bool isBusinessAccount;

  factory InstagramProfileModel.fromJson(Map<String, dynamic> json) {
    return InstagramProfileModel(
      username: json['username']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      profilePicUrl: json['profilePicUrl']?.toString(),
      biography: json['biography']?.toString(),
      postsCount: json['postsCount'] ?? 0,
      followersCount: json['followersCount'] ?? 0,
      followsCount: json['followsCount'] ?? 0,
      isPrivate: json['private'] ?? false,
      isVerified: json['verified'] ?? false,
      isBusinessAccount: json['isBusinessAccount'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        username,
        fullName,
        profilePicUrl,
        biography,
        postsCount,
        followersCount,
        followsCount,
        isPrivate,
        isVerified,
        isBusinessAccount,
      ];
}
