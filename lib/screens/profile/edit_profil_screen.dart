import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/user_profile_model.dart';
import '../../repositories/dio_client.dart';
import '../../repositories/profile_repository.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  final UserProfileModel profile;

  const EditProfileScreen({super.key, required this.user, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController usernameController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController countryController;

  final ProfileRepository repository = ProfileRepository(DioClient.createDio());

  @override
  void initState() {
    firstNameController = TextEditingController(text: widget.user.firstName);
    lastNameController = TextEditingController(text: widget.user.lastName);
    phoneController = TextEditingController(text: widget.user.phoneNumber);
    usernameController = TextEditingController(text: widget.user.username);
    addressController = TextEditingController(text: widget.profile.addressLine1);
    cityController = TextEditingController(text: widget.profile.city);
    stateController = TextEditingController(text: widget.profile.state);
    countryController = TextEditingController(text: widget.profile.country);
    super.initState();
  }

  Future<void> _submit() async {
    final updatedUser = UserModel(
      id: widget.user.id,
      email: widget.user.email,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      phoneNumber: phoneController.text,
      username: usernameController.text,
      role: widget.user.role,
      isVerified: widget.user.isVerified,
    );

    final updatedProfile = UserProfileModel(
      profilePicture: widget.profile.profilePicture,
      addressLine1: addressController.text,
      addressLine2: widget.profile.addressLine2,
      city: cityController.text,
      state: stateController.text,
      country: countryController.text,
      pinCode: widget.profile.pinCode,
      longitude: widget.profile.longitude,
      latitude: widget.profile.latitude,
      coverPhoto: widget.profile.coverPhoto,
    );

    try {
      await repository.updateProfile(updatedUser, updatedProfile);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur : $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier mon profil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: firstNameController, decoration: const InputDecoration(labelText: "Prénom")),
            TextField(controller: lastNameController, decoration: const InputDecoration(labelText: "Nom")),
            TextField(controller: usernameController, decoration: const InputDecoration(labelText: "Nom d'utilisateur")),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Téléphone")),
            TextField(controller: addressController, decoration: const InputDecoration(labelText: "Adresse")),
            TextField(controller: cityController, decoration: const InputDecoration(labelText: "Ville")),
            TextField(controller: stateController, decoration: const InputDecoration(labelText: "Département / État")),
            TextField(controller: countryController, decoration: const InputDecoration(labelText: "Pays")),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: const Text("Enregistrer les modifications"),
            )
          ],
        ),
      ),
    );
  }
}
