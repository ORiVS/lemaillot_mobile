import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 100),
              // Image + Texte
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/bell.png', // Ajoute une image de cloche dans tes assets
                      height: 120,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'No Notification yet',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: 1, // L'index de la page actuelle (notifications)
        onTap: (index) {
          // Navigation entre les pages
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              // Déjà sur cette page
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/orders');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
