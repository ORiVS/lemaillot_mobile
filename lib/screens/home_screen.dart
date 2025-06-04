import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header : avatar + cart
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage(
                      'assets/images/user.png',
                    ), // à adapter
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: const Icon(Icons.shopping_bag, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: 'Search',
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'See All',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(height: 12),

              // Product Grid
              Expanded(
                child: GridView.builder(
                  itemCount: 6, // temporaire
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[100],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/jersey$index.png',
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Positioned(
                                top: 8,
                                right: 8,
                                child: Icon(Icons.favorite_border),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Men's Jersey",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '\$55.00',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// This is the HomeScreen widget, which serves as the main screen of the app.
// It includes a bottom navigation bar, a header with an avatar and cart icon,