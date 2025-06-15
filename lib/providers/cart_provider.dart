import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lemaillot_mobile/models/cart.dart';
import 'package:lemaillot_mobile/models/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider {
  final String _baseUrl = dotenv.env['API_URL']!;
  final String _cartEndpoint = '/cart';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken'); // ou selon ton nom de clé
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// 📥 Récupérer le panier de l'utilisateur
  Future<Cart> fetchCart() async {
    final url = Uri.parse('$_baseUrl$_cartEndpoint/');
    final response = await http.get(url, headers: await _getHeaders());

    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erreur lors du chargement du panier');
    }
  }

  /// ➕ Ajouter un produit au panier
  Future<CartItem> addToCart(int productId, int quantity) async {
    final url = Uri.parse('$_baseUrl$_cartEndpoint/add/');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode({
        'product': productId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 201) {
      return CartItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Échec de l\'ajout au panier');
    }
  }

  /// 🔁 Modifier la quantité d’un produit
  Future<void> updateQuantity(int productId, int quantity) async {
    final url = Uri.parse('$_baseUrl$_cartEndpoint/update/');
    final response = await http.put(
      url,
      headers: await _getHeaders(),
      body: jsonEncode({
        'product': productId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Échec de la mise à jour');
    }
  }

  /// ❌ Supprimer un produit du panier
  Future<void> removeFromCart(int productId) async {
    final url = Uri.parse('$_baseUrl$_cartEndpoint/remove/');
    final response = await http.delete(
      url,
      headers: await _getHeaders(),
      body: jsonEncode({'product': productId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la suppression');
    }
  }

  /// 🧹 Vider le panier
  Future<void> clearCart() async {
    final url = Uri.parse('$_baseUrl$_cartEndpoint/clear/');
    final response = await http.delete(url, headers: await _getHeaders());

    if (response.statusCode != 200) {
      throw Exception('Erreur lors du vidage du panier');
    }
  }

  /// 💰 Récupérer le total du panier
  Future<double> getCartTotal() async {
    final url = Uri.parse('$_baseUrl$_cartEndpoint/total/');
    final response = await http.get(url, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['total'] as num).toDouble();
    } else {
      throw Exception('Erreur lors du calcul du total');
    }
  }
}
