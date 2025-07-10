import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../blocs/orders/order_bloc.dart';
import '../../blocs/orders/order_event.dart';
import '../../models/cart.dart';
import '../cart/cart_item_tile.dart';
import '../cart/cart_summary.dart';

class CheckoutScreen extends StatefulWidget {
  final Cart cart;

  const CheckoutScreen({super.key, required this.cart});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String deliveryMethod = 'pickup';

  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final postalCodeController = TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Finaliser la commande', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Articles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...widget.cart.items.map((item) => CartItemTile(item: item)),
          const SizedBox(height: 24),
          CartSummary(cart: widget.cart),
          const SizedBox(height: 24),
          const Text('Méthode de livraison', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          RadioListTile<String>(
            title: const Text('Retrait en boutique'),
            value: 'pickup',
            groupValue: deliveryMethod,
            onChanged: (value) => setState(() => deliveryMethod = value!),
          ),
          RadioListTile<String>(
            title: const Text('Livraison à domicile'),
            value: 'delivery',
            groupValue: deliveryMethod,
            onChanged: (value) => setState(() => deliveryMethod = value!),
          ),
          if (deliveryMethod == 'delivery') ...[
            const SizedBox(height: 12),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Adresse de livraison'),
            ),
            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: 'Ville'),
            ),
            TextField(
              controller: postalCodeController,
              decoration: const InputDecoration(labelText: 'Code postal'),
            ),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () async {
              final items = widget.cart.items.map((e) => {
                'product': e.product,
                'quantity': e.quantity,
              }).toList();

              try {
                // Crée une instance manuelle du bloc pour appeler la méthode directement
                final bloc = context.read<OrderBloc>();

                // Appel direct au repository pour créer la commande
                final orderId = await bloc.orderRepository.placeOrder(
                  deliveryMethod: deliveryMethod,
                  latitude: null,
                  longitude: null,
                  items: items,
                );

                // Appel direct au repository pour créer la session Stripe
                final checkoutUrl = await bloc.orderRepository.createStripeSession(orderId);

                // Lancer l’URL Stripe
                final uri = Uri.parse(checkoutUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  throw Exception('Impossible d’ouvrir le lien de paiement');
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur : ${e.toString()}')),
                );
              }
            },
            child: const Text('Placer la commande', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
