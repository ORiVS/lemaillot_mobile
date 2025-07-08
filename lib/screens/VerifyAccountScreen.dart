import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';

class VerifyAccountScreen extends StatefulWidget {
  final String email;
  const VerifyAccountScreen({required this.email, super.key});

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthVerificationSuccess) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Succès'),
                    content: const Text('Votre compte a été vérifié avec succès.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              } else if (state is AuthCodeResent) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Un nouveau code a été envoyé à votre email.")),
                );
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ⬅️ Bouton retour manuel
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  const SizedBox(height: 12),

                  // 🏷️ Titre centré
                  const Center(
                    child: Text(
                      'Vérifier mon compte',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 8),
                  const Center(child: Text("Un code a été envoyé à votre adresse email.")),
                  const SizedBox(height: 32),

                  const Text("Adresse mail"),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: widget.email,
                    readOnly: true,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text("Code de vérification"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Entrez le code',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 🔘 Bouton de confirmation
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final code = _codeController.text.trim();
                        if (code.isNotEmpty) {
                          context.read<AuthBloc>().add(
                            VerifyRequested(
                              email: widget.email,
                              code: code,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Continuer", style: TextStyle(color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          ResendCodeRequested(email: widget.email),
                        );
                      },
                      child: const Text(
                        "Vous n'avez pas reçu de code ? Renvoyer",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
