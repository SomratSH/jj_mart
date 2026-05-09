import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jj_mart/presentation/catagory/category_wise_product.dart';
import 'package:jj_mart/provider/category_provider/category_provider.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<CategoryProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
              // --- Header ---
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  "Explore Categories",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              // // --- Search Bar ---
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 20.0,
              //     vertical: 10,
              //   ),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Colors.white.withOpacity(0.2),
              //       borderRadius: BorderRadius.circular(15),
              //       border: Border.all(color: Colors.white.withOpacity(0.3)),
              //     ),
              //     child: const TextField(
              //       style: TextStyle(color: Colors.white),
              //       decoration: InputDecoration(
              //         hintText: "Search categories...",
              //         hintStyle: TextStyle(color: Colors.white70),
              //         prefixIcon: Icon(
              //           Icons.search_rounded,
              //           color: Colors.white,
              //         ),
              //         border: InputBorder.none,
              //         contentPadding: EdgeInsets.symmetric(vertical: 15),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10),

              // --- Grid View (Dynamic) ---
              Expanded(
                child: categoryProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : categoryProvider.categories.isEmpty
                    ? const Center(
                        child: Text(
                          "No Categories Found",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: categoryProvider.categories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // 2 items per row
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 0.90, // Adjust for card height
                            ),
                        itemBuilder: (context, index) {
                          final category = categoryProvider.categories[index];
                          return _buildGridCategoryItem(category);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridCategoryItem(category) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryWiseProduct(
                categoryId: category.id!,
                categoryName: category.name!,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Fancy Icon Container
            Container(
              padding: const EdgeInsets.all(5),

              child: category.image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        category.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.category_rounded,
                              size: 40,
                              color: Color(0xFF1E60AA),
                            ),
                      ),
                    )
                  : SvgPicture.asset(
                      height: 40,
                      width: 40,
                      category.name == "Food"
                          ? "assets/icon/food.svg"
                          : category.name == "Baby Care"
                          ? "assets/icon/baby-products.svg"
                          : category.name == "Personal Care"
                          ? "assets/icon/personal care.svg"
                          : category.name == "Home Care"
                          ? "assets/icon/home.svg"
                          : category.name == "Health & Wellness"
                          ? "assets/icon/health.svg"
                          : category.name == "Stationary"
                          ? "assets/icon/stationary.svg"
                          : category.name == "Sports"
                          ? "assets/icon/sport.svg"
                          : category.name == "Fruits & Vegetables"
                          ? "assets/icon/food.svg"
                          : category.name == "Pet Care"
                          ? "assets/icon/pet.svg"
                          : "",
                    ),
            ),
            const SizedBox(height: 5),
            Text(
              category.name ?? "Unknown",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
