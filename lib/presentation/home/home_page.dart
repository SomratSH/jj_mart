import 'package:flutter/material.dart';
import 'package:jj_mart/presentation/contact/contact_screen.dart';
import 'package:jj_mart/presentation/home/search_screen.dart';
import 'package:jj_mart/presentation/landing/landing_page.dart';
import 'package:jj_mart/provider/cart_provider/cart_provider.dart';
import 'package:jj_mart/provider/home_provider/home_provider.dart';
import 'package:jj_mart/provider/profile_provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeProvider>();
    final profileProvider = context.watch<ProfileProvider>();
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1E60AA), // Deep Blue at top
            Color(0xFF2E77BD), // Mid Blue
            Color(0xFFB0C4DE), // Light Steel Blue
            Color(0xFFE0E5EC), // Light Greyish at bottom
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildCustomAppBar(
              context,
              profileProvider.profile == null
                  ? ""
                  : profileProvider.profile!.customerImage!,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // Banner
                      _buildBanner(),
                      const SizedBox(height: 15),

                      // Section: Offer Products
                      _buildSectionHeader("Offer Products"),
                      const SizedBox(height: 10),
                      buildProductGrid(),

                      const SizedBox(height: 10),
                      _buildSeeAllButton(),

                      const SizedBox(height: 20),

                      // Section: Top Selling
                      _buildSectionHeader("Top Selling Products"),
                      const SizedBox(height: 10),
                      buildTopSellingGrid(), // Reusing grid for demo

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildCustomAppBar(BuildContext context, String profilePicture) {
  return Container(
    color: const Color(0xFF1565C0), // Dark Blue Header
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Placeholder for Logo
            Image.asset("assets/logo/logo.png", height: 30, width: 30),
            // User Avatar
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ContactScreen()),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person),
                // backgroundImage: profilePicture.isNotEmpty
                //     ? NetworkImage(profilePicture)
                //     : NetworkImage(
                //         "https://supershop.jmartbd.com//uploads//noImage.png",
                //       ),
                radius: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        // Search Bar
        // Inside _buildCustomAppBar in HomePage.dart
        TextField(
          readOnly: true, // Prevents keyboard from opening on HomePage
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          },
          decoration: InputDecoration(
            hintText: "Search any Product...",
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildBanner() {
  return Consumer<HomeProvider>(
    builder: (context, provider, child) {
      if (provider.isLoading) {
        return Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.purple),
          ),
        );
      }

      if (provider.sliders.isEmpty) {
        return const SizedBox.shrink();
      }

      return CarouselSlider.builder(
        itemCount: provider.sliders.length,
        itemBuilder: (context, index, realIndex) {
          final slider = provider.sliders[index];
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(slider.productImage),
                fit: BoxFit.cover,
                onError: (err, stack) =>
                    const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 140,
          aspectRatio: 16 / 9,
          viewportFraction: 0.9, // Shows a little bit of the next slide
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true, // Slips automatically
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true, // Makes the active slide slightly larger
          scrollDirection: Axis.horizontal,
        ),
      );
    },
  );
}

Widget _buildSectionHeader(String title) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 2,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Center(
      child: Text(
        title,
        style: TextStyle(
          color: Colors.blue[800],
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  );
}

Widget _buildSeeAllButton() {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1565C0), // Dark Blue
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      onPressed: () {},
      child: const Text("See All", style: TextStyle(color: Colors.white)),
    ),
  );
}

Widget buildProductGrid() {
  return Consumer<HomeProvider>(
    builder: (context, provider, child) {
      // 1. Show loader while fetching
      if (provider.isLoading && provider.offerProducts.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      // 2. Handle empty state
      if (provider.offerProducts.isEmpty) {
        return const Center(child: Text("No products found"));
      }

      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.62,
        ),
        itemCount: provider.offerProducts.length,
        itemBuilder: (context, index) {
          final product = provider.offerProducts[index];

          // Calculate the original price (SellingPrice + DiscountAmount)
          // to show the strike-through price
          double currentPrice = double.tryParse(product.sellingPrice) ?? 0;
          double discount = double.tryParse(product.discountAmount) ?? 0;
          double originalPrice = currentPrice + discount;

          return ProductCard(
            onTapCart: () async {
              print("tap cart");

              await Provider.of<CartProvider>(context, listen: false).addToCart(
                context: context,
                productId: product.slNo,

                productQty: 1,
              );
            },
            tag: "Offer",
            imageUrl: product.productImage,
            title: product.name,
            price: "৳${product.sellingPrice}",
            oldPrice: "৳${originalPrice.toStringAsFixed(2)}",
            // Pass the model if you need to go to a details page
            // product: product,
          );
        },
      );
    },
  );
}

Widget buildTopSellingGrid() {
  return Consumer<HomeProvider>(
    builder: (context, provider, child) {
      if (provider.isLoading && provider.topSellingProducts.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.62,
        ),
        itemCount: provider.topSellingProducts.length,
        itemBuilder: (context, index) {
          final product = provider.topSellingProducts[index];

          // Logic to show strike-through price if discount exists
          double sellingPrice = double.tryParse(product.sellingPrice) ?? 0;
          double discountAmt = double.tryParse(product.discountAmount) ?? 0;
          double originalPrice = sellingPrice + discountAmt;

          return ProductCard(
            tag: "Top Selling",
            imageUrl: product.productImage,
            title: product.name,
            price: "৳${product.sellingPrice}",
            // Only show oldPrice if there was actually a discount
            oldPrice: discountAmt > 0
                ? "৳${originalPrice.toStringAsFixed(2)}"
                : "",
            onTapCart: () async {
              await Provider.of<CartProvider>(context, listen: false).addToCart(
                context: context,
                productId: product.slNo,
                productQty: 1,
              );
            },
          );
        },
      );
    },
  );
}
