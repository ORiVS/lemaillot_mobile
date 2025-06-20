import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
  late TextEditingController emailController;
  late TextEditingController address1Controller;
  late TextEditingController address2Controller;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController countryController;
  late TextEditingController pinCodeController;

  final ProfileRepository repository = ProfileRepository(DioClient.createDio());

  @override
  void initState() {
    firstNameController = TextEditingController(text: widget.user.firstName);
    lastNameController = TextEditingController(text: widget.user.lastName);
    phoneController = TextEditingController(text: widget.user.phoneNumber);
    usernameController = TextEditingController(text: widget.user.username);
    emailController = TextEditingController(text: widget.user.email);
    address1Controller = TextEditingController(text: widget.profile.addressLine1);
    address2Controller = TextEditingController(text: widget.profile.addressLine2);
    cityController = TextEditingController(text: widget.profile.city);
    stateController = TextEditingController(text: widget.profile.state);
    countryController = TextEditingController(text: widget.profile.country);
    pinCodeController = TextEditingController(text: widget.profile.pinCode ?? '');
    super.initState();
  }

  Future<void> _submit() async {
    final updatedUser = UserModel(
      id: widget.user.id,
      email: emailController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      phoneNumber: phoneController.text,
      username: usernameController.text,
      role: widget.user.role,
      isVerified: widget.user.isVerified,
    );

    final updatedProfile = UserProfileModel(
      profilePicture: widget.profile.profilePicture,
      coverPhoto: widget.profile.coverPhoto,
      addressLine1: address1Controller.text,
      addressLine2: address2Controller.text,
      city: cityController.text,
      state: stateController.text,
      country: countryController.text,
      pinCode: pinCodeController.text,
      longitude: widget.profile.longitude,
      latitude: widget.profile.latitude,
    );

    try {
      await repository.updateProfile(updatedUser, updatedProfile);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur : \$e")));
    }
  }

  Widget _buildField(String hint, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(LucideIcons.arrowLeft, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 8),
              const Text(
                "Modifier le profil",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              _buildField("First name", firstNameController),
              _buildField("Last name", lastNameController),
              _buildField("Username", usernameController),
              _buildField("Email", emailController),
              _buildField("Numéro de téléphone", phoneController),
              _buildField("Ville", cityController),
              _buildField("Etat / Département", stateController),
              _buildField("Pays", countryController),
              _buildField("Code postal", pinCodeController),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: _submit,
                  child: const Text("Enregistrer", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
