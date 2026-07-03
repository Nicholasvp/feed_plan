import 'package:equatable/equatable.dart';
import '../../../data/models/profile_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();

  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();

  @override
  List<Object?> get props => [];
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile);

  final ProfileModel profile;

  @override
  List<Object?> get props => [profile];
}

class ProfileEmpty extends ProfileState {
  const ProfileEmpty();

  @override
  List<Object?> get props => [];
}

class ProfileError extends ProfileState {
  const ProfileError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
