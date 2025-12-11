
import 'package:flutter/material.dart';
import 'package:jj_mart/presentation/contact/contact_screen.dart';
import 'package:jj_mart/presentation/landing/landing_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
              _buildCustomAppBar(context),
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
                        buildProductGrid(itemCount: 4),
                        
                        const SizedBox(height: 10),
                        _buildSeeAllButton(),
                        
                        const SizedBox(height: 20),
      
                        // Section: Top Selling
                        _buildSectionHeader("Top Selling Products"),
                        const SizedBox(height: 10),
                        buildProductGrid(itemCount: 4), // Reusing grid for demo
                        
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
 Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      color: const Color(0xFF1565C0), // Dark Blue Header
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Placeholder for Logo
             Image.asset("assets/logo/logo.png", height: 30,width: 30,),
              // User Avatar
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_)=> ContactScreen())),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[800],
                  radius: 18,
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: "Search any Product...",
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
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
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          // Using a placeholder image similar to the banner
          image: NetworkImage("https://img.freepik.com/free-vector/gradient-supermarket-sale-banner_23-2149383637.jpg"), 
          fit: BoxFit.cover,
        ),
      ),
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

  Widget buildProductGrid({required int itemCount}) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), // Disable internal scrolling
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.62, // Adjusts height of the card relative to width
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Alternating dummy data
        final isSoap = index % 2 != 0;
        return ProductCard(
          imageUrl: isSoap 
            ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR61Lq4XzDqgXq4Xq4Xq4Xq4Xq4Xq4Xq4Xq&s" // Placeholder for soap/face wash
            : "https://m.media-amazon.com/images/I/71x+m0bM3ZL._SL1500_.jpg", // Placeholder for Nutella/Food
          title: isSoap ? "Face Wash 150ml Extra Whitening" : "Chocolate Spread Nutella 180gm",
          price: isSoap ? "৳495.00" : "৳570.00",
          oldPrice: isSoap ? "৳525.00" : "৳595.00",
        );
      },
    );
  }