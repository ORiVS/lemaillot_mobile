import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import 'VerifyAccountScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool acceptTerms = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

  bool get isFormValid => _formKey.currentState?.validate() == true && acceptTerms;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        setState(() => isLoading = state is AuthLoading);

        if (state is AuthNeedsVerification) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => VerifyAccountScreen(email: state.email),
            ),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                onChanged: () => setState(() {}),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 16),
                    const Text("Créer un compte", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 32),
                    _buildTextField("Prénom(s)", firstnameController, validator: _validateName),
                    const SizedBox(height: 16),
                    _buildTextField("Nom", lastnameController, validator: _validateName),
                    const SizedBox(height: 16),
                    _buildTextField("Adresse Email", emailController, validator: _validateEmail),
                    const SizedBox(height: 16),
                    _buildTextField("Nom d'utilisateur", usernameController, validator: _validateUsername),
                    const SizedBox(height: 16),
                    _buildTextField("Téléphone", phoneController, validator: _validatePhone),
                    const SizedBox(height: 16),
                    _buildPasswordField("Mot de passe", passwordController,
                        isVisible: showPassword,
                        toggleVisibility: () => setState(() => showPassword = !showPassword)),
                    const SizedBox(height: 16),
                    _buildPasswordField("Confirmer le mot de passe", confirmPasswordController,
                        isVisible: showConfirmPassword,
                        toggleVisibility: () => setState(() => showConfirmPassword = !showConfirmPassword),
                        validator: _validateConfirmPassword),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Checkbox(
                          value: acceptTerms,
                          onChanged: (val) => setState(() => acceptTerms = val ?? false),
                        ),
                        const Expanded(child: Text("J'accepte les conditions générales d'utilisation")),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading || !isFormValid ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Continuer", style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller,
      {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF2F2F2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  Widget _buildPasswordField(String hint, TextEditingController controller,
      {required bool isVisible,
        required VoidCallback toggleVisibility,
        String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator ?? _validatePassword,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF2F2F2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }

  void _register() {
    if (!isFormValid) return;

    context.read<AuthBloc>().add(
      RegisterRequested(
        firstName: firstnameController.text.trim(),
        lastName: lastnameController.text.trim(),
        email: emailController.text.trim(),
        username: usernameController.text.trim(),
        password: passwordController.text,
        phonenumber: phoneController.text.trim(),
      ),
    );
  }

  String? _validateEmail(String? value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (value == null || value.isEmpty) return 'Ce champ est requis';
    if (!emailRegex.hasMatch(value)) return 'Adresse email invalide';
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.length < 8) return 'Au moins 8 caractères requis';
    if (!RegExp(r'[A-Z]').hasMatch(password)) return 'Ajoutez une majuscule';
    if (!RegExp(r'[a-z]').hasMatch(password)) return 'Ajoutez une minuscule';
    if (!RegExp(r'\d').hasMatch(password)) return 'Ajoutez un chiffre';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != passwordController.text) return 'Les mots de passe ne correspondent pas';
    return null;
  }

  String? _validateUsername(String? value) {
    final username = value?.trim() ?? '';
    if (username.length < 4) return 'Minimum 4 caractères';
    if (username.contains(' ')) return 'Pas d’espaces autorisés';
    return null;
  }

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';
    if (!RegExp(r'^\d{8,}$').hasMatch(phone)) return 'Numéro invalide';
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Ce champ est requis';
    if (!RegExp(r"^[a-zA-ZÀ-ÿ '-]+$").hasMatch(value)) return 'Caractères invalides';
    return null;
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
