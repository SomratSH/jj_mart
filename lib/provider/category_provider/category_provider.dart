import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jj_mart/model/category_model.dart';
import 'package:jj_mart/model/category_wise_product.dart';
import 'package:jj_mart/presentation/catagory/category_wise_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _categories = [];
  bool _isLoading = false;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("token");
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse(
      'https://jmartbd.com/api/categories',
    ); // Replace with your URL

    try {
      final response = await http.get(url, headers:    {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },);
      if (response.statusCode == 200) {
        if(kDebugMode){
          debugPrint(response.body);
        }
        final Map<String, dynamic> decodedData = json.decode(response.body);
        final List<dynamic> data = decodedData['data'];

        _categories = data.map((item) => CategoryModel.fromJson(item)).toList();
      }
    } catch (error) {
      debugPrint("Category Fetch Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<CategoryWiseProductModel> _categoryProducts = [];

  int _currentPage = 1;

  List<CategoryWiseProductModel> get categoryProducts => _categoryProducts;

  Future<void> getCategoryWiseProduct(
    int categoryId, {
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      _categoryProducts = [];
      _currentPage = 1;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse(
        'https://jmartbd.com/api/filter_products?category=$categoryId&page=$_currentPage',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List productsJson = data['data'];

        _categoryProducts.addAll(
          productsJson
              .map((p) => CategoryWiseProductModel.fromJson(p))
              .toList(),
        );
        _currentPage++;
      }
    } catch (e) {
      debugPrint("Error fetching category products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
