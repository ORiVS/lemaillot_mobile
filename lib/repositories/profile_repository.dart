import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../models/user_profile_model.dart';

class ProfileRepository {
  final Dio dio;

  ProfileRepository(this.dio);

  Future<(UserModel, UserProfileModel)> fetchProfile() async {
    try {
      final response = await dio.get('/accounts/me/');
      print('✅ Données profil reçues : ${response.data}');
      final user = UserModel.fromJson(response.data['user']);
      final profile = UserProfileModel.fromJson(response.data['profile']);
      return (user, profile);
    } catch (e) {
      print('❌ Erreur fetchProfile : $e');
      rethrow;
    }
  }

  Future<void> updateProfile(UserModel user, UserProfileModel profile) async {
    await dio.put('/accounts/update/', data: {
      'user': user.toJson(),
      'profile': profile.toJson(),
    });
  }

  Future<void> logout(String refreshToken) async {
    await dio.post('/accounts/logout/', data: {'refresh': refreshToken});
  }
}
