import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jj_mart/presentation/all_product/all_product_page.dart';
import 'package:jj_mart/presentation/catagory/catagory_page.dart';
import 'package:jj_mart/presentation/favourite/favourite_page.dart';
import 'package:jj_mart/presentation/home/home_page.dart';
import 'package:jj_mart/presentation/profile/profile_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;
  List<Widget> page = [
    HomePage(),
    CategoryPage(),
    AllProductPage(),
    FavouritePage(),
    CartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light grey-blue bg
      // Custom AppBar area
      body: page[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
  backgroundColor: Colors.white,
  currentIndex: _selectedIndex,
  onTap: (index) => setState(() => _selectedIndex = index),
  type: BottomNavigationBarType.fixed,
  selectedItemColor: const Color(0xFF1E60AA),
  unselectedItemColor: Colors.black,
  showUnselectedLabels: true,
  items: [
    BottomNavigationBarItem(
      icon: _buildSvgIcon("assets/icon/home-button.svg", 0),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: _buildSvgIcon("assets/icon/category.svg", 1),
      label: "Category",
    ),
    BottomNavigationBarItem(
      icon: _buildSvgIcon("assets/icon/boxes.svg", 2),
      label: "All Products",
    ),
    BottomNavigationBarItem(
      icon: _buildSvgIcon("assets/icon/favorite.svg", 3),
      label: "Favorite",
    ),
    BottomNavigationBarItem(
      icon: _buildSvgIcon("assets/icon/cart.svg", 4),
      label: "Cart",
    ),
  ],
),
    );
  }
Widget _buildSvgIcon(String assetPath, int index) {
  final bool isActive = _selectedIndex == index;

  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: SvgPicture.asset(
      assetPath,
      height: 24,
      width: 24,
      // If active, null means "show original colors"
      // If inactive, apply the specific Color(0xFF1E60AA)
      colorFilter: isActive 
          ? null 
          : const ColorFilter.mode(
              Color(0xFF1E60AA), 
              BlendMode.srcIn,
            ),
    ),
  );
}
  // --- Widgets ---
}

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String oldPrice;
  final String? tag;
  final Function()  onTapCart;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.oldPrice,
    this.tag,
    required this.onTapCart
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Area with Stack for badges
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (c, o, s) =>
                          const Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
                // Discount Ribbon (Simulated)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      tag!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Heart Icon
                const Positioned(
                  top: 5,
                  right: 5,
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // Details Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  oldPrice,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.redAccent,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Add to Cart Button
                SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      onTapCart();
                    },
                    child: const Text(
                      "Add To Cart",
                      style: TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
