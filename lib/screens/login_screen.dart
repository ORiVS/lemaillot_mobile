import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

void _login() async {
  print(' Tentative de connexion depuis LoginScreen');
  await ref.read(authProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

  final state = ref.read(authProvider);
  print(' State après login : ${state.isAuthenticated}, ${state.error}');

  if (state.isAuthenticated) {
    Navigator.pushReplacementNamed(context, '/dashboard');
  } else if (state.error != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.error!)),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Mot de passe'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text('Se connecter')),
          ],
        ),
      ),
    );
  }
}
