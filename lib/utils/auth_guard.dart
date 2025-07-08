import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../main.dart'; // pour navigatorKey

Future<bool> checkAuthOrPrompt(BuildContext context) async {
  final authState = context.read<AuthBloc>().state;

  if (authState is AuthSuccess) return true;

  final shouldLogin = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Connexion requise",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text("Vous devez être connecté pour effectuer cette action."),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            "Annuler",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            "Se connecter",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );

  if (shouldLogin == true) {
    navigatorKey.currentState?.pushNamed('/login');
  }

  return false;
}

String parseApiError(DioException e) {
  final data = e.response?.data;

  if (data is Map<String, dynamic>) {
    if (data.containsKey('error')) return data['error'].toString();
    if (data.containsKey('detail')) return data['detail'].toString();

    if (data.isNotEmpty) {
      final firstKey = data.keys.first;
      final firstError = data[firstKey];
      if (firstError is List && firstError.isNotEmpty) {
        return '$firstKey: ${firstError.first}';
      } else if (firstError is String) {
        return '$firstKey: $firstError';
      }
    }
  }

  return 'Erreur inconnue : ${e.message}';
}
