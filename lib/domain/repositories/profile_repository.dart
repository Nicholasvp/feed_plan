import '../../data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> createProfile(ProfileModel profile);
  Future<ProfileModel?> getProfile(String id);
  Future<ProfileModel?> getFirstProfile();
  Future<List<ProfileModel>> getAllProfiles();
  Future<ProfileModel> updateProfile(ProfileModel profile);
  Future<void> deleteProfile(String id);
}
