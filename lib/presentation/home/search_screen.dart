import 'dart:convert';
import 'dart:async'; // REQUIRED: For the Timer class
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jj_mart/model/top_selling_product.dart';
import 'package:jj_mart/presentation/landing/landing_page.dart';
import 'package:provider/provider.dart';
import 'package:jj_mart/provider/cart_provider/cart_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<TopSellingProduct> _results = [];
  bool _isLoading = false;

  // --- Debounce Configuration ---
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel(); // Always cancel timers when disposing screens
    super.dispose();
  }

  // This handles the keystroke waiting logic
  void _onSearchChanged(String query) {
    // 1. Cancel the previous timer if the user is still typing
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    // 2. Set up a new timer for 3 seconds
    _debounceTimer = Timer(const Duration(seconds: 2), () {
      if (query.isNotEmpty) {
        _performSearch(query);
      } else {
        setState(() => _results = []);
      }
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("token");
      final String baseUrl = "https://jmartbd.com/api";

      final response = await http.get(
        Uri.parse("$baseUrl/filter_products?search_product=$query"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded["status"] == true) {
          final List data = decoded["data"];
          setState(() {
            _results = data
                .map((item) => TopSellingProduct.fromJson(item))
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Search error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E60AA),
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          // CHANGED: Combined both real-time typing and keyboard action trigger
          onChanged: _onSearchChanged,
          onSubmitted: (value) {
            _debounceTimer
                ?.cancel(); // Cancel timer if they explicitly hit enter
            _performSearch(value);
          },
          decoration: const InputDecoration(
            hintText: "Search products...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _debounceTimer?.cancel();
              _searchController.clear();
              setState(() => _results = []);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
          ? _buildEmptyState()
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final product = _results[index];
                return ProductCard(
                  imageUrl: product.productImage,
                  title: product.name,
                  price: "৳${product.sellingPrice}",
                  oldPrice: "",
                  tag: "Result",
                  onTapCart: () {
                    context.read<CartProvider>().addToCart(
                      context: context,
                      productId: product.slNo,
                      productQty: 1,
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isEmpty
                ? "Type to search products"
                : "No results found",
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}
