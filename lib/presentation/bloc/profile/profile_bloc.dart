import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/profile_model.dart';
import '../../../data/repositories/profile_repository_impl.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._repository) : super(const ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<CreateNewProfile>(_onCreateProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<IncrementPostCount>(_onIncrementPostCount);
  }

  final ProfileRepositoryImpl _repository;

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final profile = await _repository.getFirstProfile();
      if (profile != null) {
        emit(ProfileLoaded(profile));
      } else {
        emit(const ProfileEmpty());
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onCreateProfile(
    CreateNewProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final profile = await _repository.createProfile(
        ProfileModel(
          id: '',
          name: event.name,
          bio: event.bio,
          avatarPath: event.avatarPath,
          postCount: 0,
          followerCount: event.followerCount,
          followingCount: event.followingCount,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final updated = await _repository.updateProfile(event.profile);
      emit(ProfileLoaded(updated));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onIncrementPostCount(
    IncrementPostCount event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      final current = (state as ProfileLoaded).profile;
      final updated = current.copyWith(postCount: current.postCount + 1);
      try {
        final saved = await _repository.updateProfile(updated);
        emit(ProfileLoaded(saved));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    }
  }
}
