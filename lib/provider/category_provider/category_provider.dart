import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jj_mart/model/category_model.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _categories = [];
  bool _isLoading = false;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse(
      'https://jmartbd.com/api/categories',
    ); // Replace with your URL

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
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
}
