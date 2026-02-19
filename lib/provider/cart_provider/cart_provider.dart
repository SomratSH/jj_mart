import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jj_mart/model/cart_item_model.dart';
import 'package:jj_mart/model/cart_response_model.dart';
import 'package:jj_mart/model/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItemModel> _items = {};
  bool _isLoading = false;

  Map<String, CartItemModel> get items => _items;
  bool get isLoading => _isLoading;
  ProfileModel? _profile;

  ProfileModel? get profile => _profile;

  Future<void> fetchProfile() async {
    const url =
        "https://jmartbd.com/api/profile"; // Replace with your actual endpoint
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("token");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded["status"] == true) {
        _profile = ProfileModel.fromJson(decoded["data"]);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Profile Fetch Error: $e");
    } finally {}
  }

  Future<void> addToCart({
    required int productId,
    required int productQty,

    required BuildContext context,
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
          "product_quantity": productQty,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // // Parsing the dynamic "cart" map
        // Map<String, dynamic> cartData = data['cart'];
        // _items = cartData.map(
        //   (key, value) => MapEntry(key, CartItemModel.fromJson(value)),
        // );

        if (data["status"] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data["message"]),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data["message"]),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (error) {
      print("Error adding to cart: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool cartLoading = false;
  CartResponse cartResponse = CartResponse();
  Future<void> getCartApi() async {
    cartLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");
    try {
      // Replace with your actual URL
      final response = await http.get(
        Uri.parse('https://jmartbd.com/api/shopping_cart/load_cart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
        cartResponse = CartResponse.fromJson(jsonDecode(response.body));
        cartLoading = false;
        notifyListeners();
      }
    } catch (e) {
      cartLoading = false;
      notifyListeners();
      debugPrint("Error fetching cart: $e");
    }
  }

  Future<String> placeOrder({
    required String address,
    required String phone,
    required String name,
    required int paymentType,
    required int areaId,
  }) async {
    final url = Uri.parse('https://jmartbd.com/api/shopping_cart/placeOrder');

    try {
      // 1. Get the saved token
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      // 2. Prepare the body
      final Map<String, dynamic> body = {
        "shippingAddress": address,
        "shipping_phone": phone,
        "shipping_name": name,
        "payment_type": paymentType,
        "area_id": areaId,
      };

      // 3. Make the POST call
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Sends your login token
        },
        body: jsonEncode(body),
      );

      // 4. Handle the response
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        print("Order Success: ${responseData['message']}");

        cartResponse = CartResponse();
        notifyListeners();
        return responseData['message'];
        // Navigate to a success screen or show a dialog
      } else {
        print("Order Failed: ${responseData['message']}");
        return responseData['message'];
      }
    } catch (e) {
      print("Error placing order: $e");
      return "Please, try ageain";
    }
  }
}
