import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jj_mart/model/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  ProfileModel? _profile;
  bool _isLoading = false;

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();

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
      }
    } catch (e) {
      debugPrint("Profile Fetch Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
