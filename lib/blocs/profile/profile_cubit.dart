import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/profile_repository.dart';
import '../../models/user_model.dart';
import '../../models/user_profile_model.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  late UserModel currentUser;
  late UserProfileModel currentProfile;

  ProfileCubit(this.repository) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final (user, profile) = await repository.fetchProfile();
      currentUser = user;
      currentProfile = profile;
      emit(ProfileLoaded(user, profile));
    } catch (e) {
      emit(ProfileError("Impossible de charger le profil : ${e.toString()}"));
    }
  }

  Future<void> updateProfile(UserModel user, UserProfileModel profile) async {
    emit(ProfileUpdating());
    try {
      await repository.updateProfile(user, profile);
      await loadProfile(); // Recharge les données
      emit(ProfileUpdated());
    } catch (e) {
      emit(ProfileError("Erreur lors de la mise à jour"));
    }
  }

  Future<void> logout(String refreshToken) async {
    await repository.logout(refreshToken);
  }
}
