import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jj_mart/model/offer_product_model.dart';
import 'package:jj_mart/model/slider_model.dart';
import 'package:jj_mart/model/top_selling_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  final String baseUrl = "https://jmartbd.com/api";

  List<SliderModel> _sliders = [];
  bool _isLoading = false;

  List<SliderModel> get sliders => _sliders;
  bool get isLoading => _isLoading;

  Future<void> getSliders() async {
    _isLoading = true;
    // notifyListeners(); // Optional: call here if you want to show loader immediately

    final url = Uri.parse("$baseUrl/sliders");

    try {
      // 1. Retrieve the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("token");

      // 2. Make the request with the Authorization header
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Add the Bearer token here
          'Authorization': 'Bearer $token',
        },
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded["status"] == true) {
        List<dynamic> data = decoded["data"];
        _sliders = data.map((item) => SliderModel.fromJson(item)).toList();
      } else {
        debugPrint("API Error: ${decoded["message"]}");
      }
    } catch (e) {
      debugPrint("Slider Exception: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<OfferProductModel> _offerProducts = [];
  List<OfferProductModel> get offerProducts => _offerProducts;
  int _currentOfferPage = 1;
  bool _isFetchingMoreOffers = false;
  bool _hasMoreOffers = true;
  bool get isFetchingMoreOffers => _isFetchingMoreOffers;
  Future<void> getOfferProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentOfferPage = 1;
      _offerProducts = [];
      _hasMoreOffers = true;
      _isLoading = true; // Show full screen loader only on first load
    }

    // Prevent duplicate calls or calling when no more data
    if (_isFetchingMoreOffers || !_hasMoreOffers) return;

    _isFetchingMoreOffers = true;
    notifyListeners();

    final url = Uri.parse(
      "$baseUrl/offer-product?page=$_currentOfferPage&page_items=15",
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("token");

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded["status"] == true) {
        List<dynamic> data = decoded["data"];

        if (data.isEmpty) {
          _hasMoreOffers = false;
        } else {
          List<OfferProductModel> newProducts = data
              .map((item) => OfferProductModel.fromJson(item))
              .toList();

          _offerProducts.addAll(newProducts);
          _currentOfferPage++; // Increment for next scroll trigger
        }
      }
    } catch (e) {
      debugPrint("Offer Product Error: $e");
    } finally {
      _isLoading = false;
      _isFetchingMoreOffers = false;
      notifyListeners();
    }
  }

  List<TopSellingProduct> _topSellingProducts = [];
  List<TopSellingProduct> get topSellingProducts => _topSellingProducts;

  Future<void> fetchTopSellingProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("token");
      final response = await http.get(
        Uri.parse("$baseUrl/top_selling_products?q="),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);

        if (decodedData['status'] == true) {
          List<dynamic> data = decodedData['data'];
          _topSellingProducts = data
              .map((item) => TopSellingProduct.fromJson(item))
              .toList();
        }
      }
    } catch (e) {
      print("Error fetching top selling products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
