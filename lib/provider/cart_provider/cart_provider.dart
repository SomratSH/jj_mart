import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jj_mart/model/cart_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CartProvider with ChangeNotifier {
  Map<String, CartItemModel> _items = {};
  bool _isLoading = false;

  Map<String, CartItemModel> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> addToCart({
    required int productId,
    required String name,
    required double price,
    required int productQty,
    required double purchasePrice,
    required String image,
    required int quantity,
    required BuildContext context
  }) async {
     final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("token");
    _isLoading = true;
    notifyListeners();

    const url = 'https://jmartbd.com/api/shopping_cart/add';
    
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "product_id": productId,
          "product_name": name,
          "product_price": price,
          "product_quantity": productQty,
          "purchase_price": purchasePrice,
          "product_image": image,
          "quantity": quantity,
        }),
         headers:    {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }

      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Parsing the dynamic "cart" map
        Map<String, dynamic> cartData = data['cart'];
        _items = cartData.map((key, value) => MapEntry(key, CartItemModel.fromJson(value)));
        
        print(data['message']);
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully updated cart"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (error) {
      print("Error adding to cart: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}