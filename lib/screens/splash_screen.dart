import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../repositories/auth_repoositories.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(authRepository: AuthRepository());
    _authBloc.add(const AuthStatusChecked());
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else if (state is Unauthenticated) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/images/logo.webp', height: 120),
                const SizedBox(height: 20),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
