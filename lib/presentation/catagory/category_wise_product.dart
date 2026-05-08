import 'package:flutter/material.dart';
import 'package:jj_mart/model/category_wise_product.dart';
import 'package:jj_mart/presentation/landing/landing_page.dart';
import 'package:jj_mart/provider/cart_provider/cart_provider.dart';
import 'package:jj_mart/provider/category_provider/category_provider.dart';
import 'package:provider/provider.dart';

class CategoryWiseProduct extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryWiseProduct({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryWiseProduct> createState() => _CategoryWiseProductState();
}

class _CategoryWiseProductState extends State<CategoryWiseProduct> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(
        context,
        listen: false,
      ).getCategoryWiseProduct(widget.categoryId, isRefresh: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        Provider.of<CategoryProvider>(
          context,
          listen: false,
        ).getCategoryWiseProduct(widget.categoryId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      body: Container(
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
              // Header with Back Button
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        widget.categoryName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance for back button
                  ],
                ),
              ),

              // Product Grid
              Expanded(
                child: provider.isLoading && provider.categoryProducts.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : provider.categoryProducts.isEmpty
                    ? const Center(child: Text("No products found"))
                    : GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: provider.categoryProducts.length,
                        itemBuilder: (context, index) {
                          final product = provider.categoryProducts[index];
                          double currentPrice =
                              double.tryParse(product.sellingPrice!) ?? 0;
                          double discount =
                              double.tryParse(product.discountAmount!) ?? 0;
                          double originalPrice = currentPrice + discount;
                          return ProductCard(
                            onTapCart: () async {
                              print("tap cart");

                              await Provider.of<CartProvider>(
                                context,
                                listen: false,
                              ).addToCart(
                                context: context,
                                productId: product.id!,

                                productQty: 1,
                              );
                            },
                            tag: "Offer",
                            imageUrl: product.productImage!,
                            title: product.name!,
                            price: "৳${product.sellingPrice}",
                            oldPrice: "৳$originalPrice",
                            // Pass the model if you need to go to a details page
                            // product: product,
                          );
                          ;
                        },
                      ),
              ),

              if (provider.isLoading && provider.categoryProducts.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildProductCard(CategoryWiseProductModel product) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Expanded(
  //           child: ClipRRect(
  //             borderRadius: const BorderRadius.vertical(
  //               top: Radius.circular(15),
  //             ),
  //             child: Image.network(
  //               product.productImage ?? '',
  //               fit: BoxFit.cover,
  //               width: double.infinity,
  //               errorBuilder: (context, error, stackTrace) =>
  //                   const Icon(Icons.image_not_supported),
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 product.name ?? '',
  //                 maxLines: 2,
  //                 overflow: TextOverflow.ellipsis,
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 14,
  //                 ),
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 "৳${product.sellingPrice}",
  //                 style: const TextStyle(
  //                   color: Colors.blue,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
