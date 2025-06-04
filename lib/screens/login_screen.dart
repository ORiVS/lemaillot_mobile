import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../repositories/auth_repoositories.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onLoginPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    context.read<AuthBloc>().add(
      LoginRequested(email: email, password: password),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _socialButton({required IconData icon, required String text}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListTile(
        leading: Icon(icon, size: 24),
        title: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        horizontalTitleGap: 0,
        minLeadingWidth: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Image.asset('assets/images/logo.png', height: 80),
                  const SizedBox(height: 30),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is AuthLoading ? null : _onLoginPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child:
                          state is AuthLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                'Continue',
                                style: TextStyle(color: Colors.white),
                              ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Don't have an Account ? "),
                      Text(
                        "Create One",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _socialButton(icon: Icons.apple, text: 'Continue With Apple'),
                  _socialButton(
                    icon: Icons.g_mobiledata,
                    text: 'Continue With Google',
                  ),
                  _socialButton(
                    icon: Icons.facebook,
                    text: 'Continue With Facebook',
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
