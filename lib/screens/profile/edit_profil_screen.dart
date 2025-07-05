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
  final _formKey = GlobalKey<FormState>();
  final ProfileRepository repository = ProfileRepository(DioClient.createDio());

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
    if (!_formKey.currentState!.validate()) return;

    final updatedUser = UserModel(
      id: widget.user.id,
      email: emailController.text.trim(),
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      username: usernameController.text.trim(),
      role: widget.user.role,
      isVerified: widget.user.isVerified,
    );

    final updatedProfile = UserProfileModel(
      profilePicture: widget.profile.profilePicture,
      coverPhoto: widget.profile.coverPhoto,
      addressLine1: address1Controller.text.trim(),
      addressLine2: address2Controller.text.trim(),
      city: cityController.text.trim(),
      state: stateController.text.trim(),
      country: countryController.text.trim(),
      pinCode: pinCodeController.text.trim(),
      longitude: widget.profile.longitude,
      latitude: widget.profile.latitude,
    );

    try {
      await repository.updateProfile(updatedUser, updatedProfile);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la mise à jour : $e")),
      );
    }
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType type = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: validator,
        decoration: InputDecoration(
          hintText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: InputBorder.none,
        ),
      ),
    );
  }

  String? _required(String? value) => value == null || value.trim().isEmpty ? "Ce champ est requis" : null;

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return "Champ requis";
    final regex = RegExp(r'^[A-Za-zÀ-ÿ\- ]+$');
    return regex.hasMatch(value.trim()) ? null : "Lettres uniquement";
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) return "Champ requis";
    if (value.length < 4) return "Min. 4 caractères";
    final regex = RegExp(r'^[a-zA-Z0-9_]+$');
    return regex.hasMatch(value) ? null : "Uniquement lettres, chiffres ou _";
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return "Champ requis";
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return regex.hasMatch(value.trim()) ? null : "Email invalide";
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return "Champ requis";
    final regex = RegExp(r'^\+\d{8,15}$');
    return regex.hasMatch(value.trim()) ? null : "Format: +22990000000";
  }

  String? _validateOptionalText(String? value) {
    if (value == null || value.isEmpty) return null;
    final regex = RegExp(r'^[A-Za-zÀ-ÿ\- ]+$');
    return regex.hasMatch(value) ? null : "Caractères non autorisés";
  }

  String? _validatePinCode(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^\d{4,10}$');
    return regex.hasMatch(value) ? null : "Code postal invalide";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
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
                _buildField(label: "Prénom", controller: firstNameController, validator: _validateName),
                _buildField(label: "Nom", controller: lastNameController, validator: _validateName),
                _buildField(label: "Nom d'utilisateur", controller: usernameController, validator: _validateUsername),
                _buildField(label: "Email", controller: emailController, validator: _validateEmail, type: TextInputType.emailAddress),
                _buildField(label: "Numéro de téléphone", controller: phoneController, validator: _validatePhone, type: TextInputType.phone),
                _buildField(label: "Adresse ligne 1", controller: address1Controller, validator: (_) => null),
                _buildField(label: "Adresse ligne 2", controller: address2Controller, validator: (_) => null),
                _buildField(label: "Ville", controller: cityController, validator: _validateOptionalText),
                _buildField(label: "Département / État", controller: stateController, validator: _validateOptionalText),
                _buildField(label: "Pays", controller: countryController, validator: _validateOptionalText),
                _buildField(label: "Code postal", controller: pinCodeController, validator: _validatePinCode, type: TextInputType.number),
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
      ),
    );
  }
}
