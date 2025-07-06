import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../blocs/orders/order_bloc.dart';
import '../../blocs/orders/order_event.dart';
import '../../blocs/orders/order_state.dart';
import '../../models/order_model.dart';

class OrderDetailScreen extends StatelessWidget {
  final int orderId;

  OrderDetailScreen({super.key, required this.orderId});

  final List<String> timelineSteps = [
    'pending', 'confirmed', 'shipped', 'delivered', 'cancelled'
  ];

  String translateStatus(String status) {
    switch (status) {
      case 'pending': return 'En attente';
      case 'confirmed': return 'Confirmée';
      case 'shipped': return 'Expédiée';
      case 'delivered': return 'Livrée';
      case 'cancelled': return 'Annulée';
      default: return status;
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case 'pending': return Colors.amber.shade100;
      case 'confirmed': return Colors.blue.shade100;
      case 'shipped': return Colors.orange.shade100;
      case 'delivered': return Colors.green.shade100;
      case 'cancelled': return Colors.red.shade100;
      default: return Colors.grey.shade200;
    }
  }

  int getCurrentStep(String status) => timelineSteps.indexOf(status);

  Future<void> downloadInvoice(int orderId, BuildContext context) async {
    try {
      final dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token'); // ✅ bonne clé ici

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Token non trouvé. Veuillez vous reconnecter.')),
        );
        return;
      }

      final baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:8000'; // ✅ cohérent avec le reste du projet
      final url = '$baseUrl/orders/$orderId/export/';

      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/facture_commande_$orderId.pdf';

      final response = await dio.download(
        url,
        filePath,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        await OpenFile.open(filePath);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec du téléchargement (${response.statusCode})')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du téléchargement : $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    context.read<OrderBloc>().add(FetchOrderDetail(orderId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderDetailLoaded) {
            final order = state.order;

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(LucideIcons.arrowLeft),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    const Text(
                      "Détail commande",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),

                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Commande #${order.orderNumber}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("Date : ${order.createdAt.split('T').first}"),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text("Statut : ", style: TextStyle(fontWeight: FontWeight.w600)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor(order.status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              translateStatus(order.status),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Text("Articles commandés", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...order.items.map((item) => Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.shirt, size: 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text("Vendeur : ${item.vendorName}", style: const TextStyle(color: Colors.grey)),
                              Text("Quantité : ${item.quantity}", style: const TextStyle(color: Colors.grey)),
                              Text("Prix unitaire : ${item.price.toStringAsFixed(0)} FCFA",
                                  style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        Text("${(item.quantity * item.price).toStringAsFixed(0)} FCFA",
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )),

                const SizedBox(height: 24),
                const Text("Méthode de livraison", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(order.deliveryMethod == 'delivery' ? LucideIcons.truck : LucideIcons.store, size: 20),
                    const SizedBox(width: 8),
                    Text(order.deliveryMethod == 'delivery' ? 'Livraison à domicile' : 'Retrait en boutique'),
                  ],
                ),

                const SizedBox(height: 12),
                if (order.deliveryMethod == 'delivery')
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(LucideIcons.mapPin, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          order.deliveryAddress != null && order.deliveryAddress!.isNotEmpty
                              ? "${order.deliveryAddress}, ${order.deliveryPostalCode ?? ''} ${order.deliveryCity ?? ''}, ${order.deliveryCountry ?? ''}"
                              : "Adresse complète non disponible",
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Montant total :", style: TextStyle(color: Colors.white)),
                      Text("${order.totalPrice.toStringAsFixed(0)} FCFA",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (_) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Suivi de la commande", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              Stepper(
                                currentStep: getCurrentStep(order.status),
                                physics: const NeverScrollableScrollPhysics(),
                                controlsBuilder: (_, __) => const SizedBox.shrink(),
                                steps: timelineSteps.take(4).map((step) {
                                  final index = getCurrentStep(step);
                                  return Step(
                                    title: Text(translateStatus(step)),
                                    content: const SizedBox(),
                                    isActive: getCurrentStep(order.status) >= index,
                                    state: getCurrentStep(order.status) > index
                                        ? StepState.complete
                                        : StepState.indexed,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(LucideIcons.navigation),
                  label: const Text("Suivre la commande"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => downloadInvoice(order.id, context),
                  icon: const Icon(LucideIcons.download),
                  label: const Text("Télécharger la facture"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            );
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
