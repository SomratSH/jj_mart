import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jj_mart/presentation/auth/login_page.dart';
import 'package:jj_mart/presentation/landing/landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final String baseUrl = "https://jmartbd.com/api";

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String mobile,
    required String password,
    required String address,
    required String areaId,
    required BuildContext context,
  }) async {
    _setLoading(true);

    final url = Uri.parse("$baseUrl/register");

    final body = {
      "user_name": name,
      "user_mobile": mobile,
      "user_password": password,
      "user_address": address,
      "area_id": areaId,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded["status"] == true) {
        // await _saveAuthData(decoded);

        // Success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(decoded["message"] ?? "Registration successful"),
            backgroundColor: Colors.green,
          ),
        );

        // Move to login page
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => JMartSignInScreen()),
          (route) => false,
        );
      } else {
        _showError(context, decoded["message"] ?? "Registration failed");
      }
    } catch (e) {
      _showError(context, "Something went wrong");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => JMartSignInScreen()),
      (route) => false,
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> login({
    required String phone,
    required String password,
    required BuildContext context,
  }) async {
    _setLoading(true);

    final url = Uri.parse("$baseUrl/login");

    // Exact body keys as per your requirement
    final body = {"phone": phone, "password": password};

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded["status"] == true) {
        // Save data to SharedPreferences
        await _saveAuthData(decoded);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(decoded["message"] ?? "Login successful"),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to the main Landing Page (CurvedNavWrapper)
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LandingPage()),
          (route) => false,
        );
      } else {
        _showError(context, decoded["message"] ?? "Login failed");
      }
    } catch (e) {
      _showError(context, "An error occurred: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _saveAuthData(Map<String, dynamic> response) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = response["data"];

    // Saving the main auth token
    await prefs.setString("token", response["token"] ?? "");

    // Saving user specific data from the "data" object
    await prefs.setInt("customer_id", userData["Customer_SlNo"] ?? 0);
    await prefs.setString("customer_code", userData["Customer_Code"] ?? "");
    await prefs.setString("customer_name", userData["Customer_Name"] ?? "");
    await prefs.setString("customer_mobile", userData["Customer_Mobile"] ?? "");
    await prefs.setString(
      "customer_address",
      userData["Customer_Address"] ?? "",
    );
    await prefs.setString("customer_image", userData["customer_image"] ?? "");

    // Optional: Save points or credit limit if needed
    await prefs.setString("points", userData["point"].toString());
  }
}
