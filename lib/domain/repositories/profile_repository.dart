import '../models/learner_profile_model.dart';

abstract class ProfileRepository {
  Future<List<LearnerProfileModel>> getAllProfiles();
  Future<LearnerProfileModel?> getActiveProfile();
  Future<void> setActiveProfile(String profileId);
  Future<void> saveProfile(LearnerProfileModel profile);
  Future<void> deleteProfile(String profileId);
}
