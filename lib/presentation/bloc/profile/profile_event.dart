import 'package:equatable/equatable.dart';
import '../../../data/models/profile_model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();

  @override
  List<Object?> get props => [];
}

class CreateNewProfile extends ProfileEvent {
  const CreateNewProfile({
    required this.name,
    this.bio,
    this.avatarPath,
    this.followerCount = 0,
    this.followingCount = 0,
  });

  final String name;
  final String? bio;
  final String? avatarPath;
  final int followerCount;
  final int followingCount;

  @override
  List<Object?> get props => [name, bio, avatarPath, followerCount, followingCount];
}

class UpdateProfile extends ProfileEvent {
  const UpdateProfile(this.profile);

  final ProfileModel profile;

  @override
  List<Object?> get props => [profile];
}

class IncrementPostCount extends ProfileEvent {
  const IncrementPostCount();

  @override
  List<Object?> get props => [];
}
