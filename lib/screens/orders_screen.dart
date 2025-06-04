import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String selectedFilter = 'Processing';

  final List<String> filters = [
    'Processing',
    'Shipped',
    'Delivered',
    'Returned',
    'Canceled',
  ];

  final List<Map<String, dynamic>> orders = [
    {'number': '#456765', 'items': 4},
    {'number': '#454569', 'items': 2},
    {'number': '#454809', 'items': 1},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Orders',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              // Filtres
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    final isSelected = filter == selectedFilter;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Liste des commandes ou message vide
              Expanded(
                child:
                    orders.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/cart.png', // Ajoute l'icône panier dans tes assets
                                height: 120,
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'No Orders yet',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.receipt_long),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Order ${order['number']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text('${order['items']} items'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.arrow_forward_ios, size: 16),
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
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: 2, // Index pour les commandes
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/notifications');
              break;
            case 2:
              // Déjà ici
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
