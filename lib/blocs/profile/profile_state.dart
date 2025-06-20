import '../../models/user_model.dart';
import '../../models/user_profile_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  final UserProfileModel profile;

  ProfileLoaded(this.user, this.profile);
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdated extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
