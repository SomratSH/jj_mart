import 'package:flutter/material.dart';
import 'package:jj_mart/presentation/home/search_screen.dart';
import 'package:jj_mart/presentation/landing/landing_page.dart';
import 'package:jj_mart/provider/cart_provider/cart_provider.dart';
import 'package:jj_mart/provider/home_provider/home_provider.dart';
import 'package:provider/provider.dart';

class AllProductPage extends StatefulWidget {
  const AllProductPage({super.key});

  @override
  State<AllProductPage> createState() => _AllProductPageState();
}

class _AllProductPageState extends State<AllProductPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch first page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(
        context,
        listen: false,
      ).getAllProducts(isRefresh: true);
    });

    // Setup scroll listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Trigger next page when 200px from bottom
        Provider.of<HomeProvider>(context, listen: false).getAllProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E60AA),
              Color(0xFF2E77BD),
              Color(0xFFB0C4DE),
              Color(0xFFE0E5EC),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Offer Products",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SearchScreen()),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: "Search any Product...",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Product List with Pagination
              Expanded(
                child: provider.isLoading && provider.offerProducts.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : ListView(
                        controller: _scrollController, // Attach controller here
                        padding: const EdgeInsets.all(8.0),
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.allProduct.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                            itemBuilder: (context, index) {
                              final product = provider.allProduct[index];
                              return ProductCard(
                                onTapCart: () async {
                                  await Provider.of<CartProvider>(
                                    context,
                                    listen: false,
                                  ).addToCart(
                                    context: context,
                                    productId: product.slNo,

                                    productQty: 1,
                                  );
                                },
                                tag: "",
                                imageUrl: product.productImage,
                                title: product.name,
                                price: "৳${product.sellingPrice}",
                                oldPrice:
                                    "৳${(double.parse(product.sellingPrice) + double.parse(product.discountAmount)).toStringAsFixed(0)}",
                              ); // Use your custom card
                            },
                          ),

                          // Loading Indicator at the bottom
                          if (provider.isFetchingMoreOffers)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
