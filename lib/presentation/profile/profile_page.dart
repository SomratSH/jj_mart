import 'package:flutter/material.dart';
import 'package:jj_mart/model/cart_response_model.dart';
import 'package:jj_mart/provider/cart_provider/cart_provider.dart';
import 'package:jj_mart/provider/profile_provider/profile_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout();
  }
}

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  // final String deliveryAddress = 'House-4, Block-D, Basundhara R/A';
  // final String phoneNumber = '01712344561';

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CartProvider>();
    final profileProvider = context.watch<ProfileProvider>();

    // final total = cartItems.fold<double>(
    //   0,
    //   (sum, item) => sum + (item.price * item.quantity),
    // );
    // const deliveryCharge = 30.0;
    // final subTotal = total + deliveryCharge;

    return Scaffold(
      body: Container(
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
          child: controller.cartLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async {
                    await controller.getCartApi();
                  },
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Shopping Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // Cart Items
                        // Check if the cart is null or empty first
                        controller.cartResponse.cart == null ||
                                controller.cartResponse.cart!.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.shopping_cart_outlined,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Your cart is empty",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Column(
                                // If not empty, show the items
                                children: [
                                  ...controller.cartResponse.cart!
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                        final index = entry.key;
                                        final item = entry.value;
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: _buildCartItem(
                                            item,
                                            index,
                                            controller,
                                          ),
                                        );
                                      })
                                      .toList(),
                                ],
                              ),

                        const SizedBox(height: 16),

                        // Price Summary Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _buildPriceRow(
                                'Total :',
                                controller.cartResponse.total == null
                                    ? "0"
                                    : controller.cartResponse.total!
                                          .toStringAsFixed(0),
                              ),
                              const SizedBox(height: 8),
                              _buildPriceRow(
                                'Delivery Charge :',
                                controller.cartResponse.deliveryCharge == null
                                    ? "0"
                                    : controller.cartResponse.deliveryCharge!
                                          .toStringAsFixed(0),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Purchase at least 2000 taka more for free delivery',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              _buildPriceRow(
                                'Sub Total :',
                                controller.cartResponse.subTotal == null
                                    ? "0"
                                    : controller.cartResponse.subTotal!
                                          .toStringAsFixed(0),
                                isTotal: true,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Clear Cart Button
                        OutlinedButton.icon(
                          onPressed: () async {
                            await controller.clearCart(context);
                          },
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text('Clear Cart'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1565C0),
                            side: const BorderSide(color: Color(0xFF1565C0)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Delivery Address Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Delivery Address',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1565C0),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                profileProvider.profile!.customerAddress ??
                                    "N/A",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Number : ${profileProvider.profile!.customerMobile ?? "N/A"}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                              // const SizedBox(height: 12),
                              // OutlinedButton(
                              //   onPressed: () {
                              //     _showChangeLocationDialog(context);
                              //   },
                              //   style: OutlinedButton.styleFrom(
                              //     foregroundColor: const Color(0xFF1565C0),
                              //     side: const BorderSide(
                              //       color: Color(0xFF1565C0),
                              //     ),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(8),
                              //     ),
                              //     minimumSize: const Size(double.infinity, 40),
                              //   ),
                              //   child: const Text('Change Location'),
                              // ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Place Order Button
                        ElevatedButton(
                          // 1. Block interactions if provider reports active network process loading
                          onPressed: controller.plaseOrderLoading
                              ? null
                              : () async {
                                  final cartList = controller.cartResponse.cart;
                                  if (cartList == null || cartList.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Cart is empty'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  if (controller.profile == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Profile information not found',
                                        ),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                    return;
                                  }

                                  // 2. Just call the method. The provider manages the loading lifecycle flags internally
                                  final response = await controller.placeOrder(
                                    address:
                                        controller.profile!.customerAddress ??
                                        "N/A",
                                    phone:
                                        controller.profile!.customerMobile ??
                                        "N/A",
                                    name:
                                        controller.profile!.customerName ??
                                        "Customer",
                                    paymentType: 1,
                                    areaId:
                                        int.tryParse(
                                          controller.profile!.areaId
                                                  ?.toString() ??
                                              '0',
                                        ) ??
                                        0,
                                  );

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(response),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            disabledBackgroundColor: const Color(
                              0xFF1565C0,
                            ).withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                          ),
                          // 3. Listen to the provider state variable to swap text out for a Loader
                          child: controller.plaseOrderLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Place Order',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCartItem(Cart item, int index, CartProvider provider) {
    // 1. Parse and sanitize pricing details securely
    final double basePrice =
        double.tryParse(item.price?.toString() ?? '0.0') ?? 0.0;
    final double discount =
        double.tryParse(item.discountAmount?.toString() ?? '0.0') ?? 0.0;
    final double finalPrice = basePrice - discount;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Product Image Placeholder
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: item.image != null && item.image!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        "assets/image/no_image_found.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Image.asset(
                    "assets/image/no_image_found.png",
                    fit: BoxFit.cover,
                  ),
          ),

          const SizedBox(width: 12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? "Unknown Product",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1565C0),
                  ),
                ),
                const SizedBox(height: 4),

                // Price Layout with Discount Check
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  children: [
                    Text(
                      '৳${finalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    if (discount > 0)
                      Text(
                        '৳${basePrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Quantity Controls
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 16),
                  onPressed: () async {
                    int currentQty =
                        int.tryParse(item.quantity?.toString() ?? '1') ?? 1;
                    if (currentQty > 1) {
                      currentQty--;
                      await provider.decraseQty(
                        productId: item.id!,
                        qty: currentQty,
                        context: context,
                      );
                      // Call your provider method here to decrement quantity
                      // e.g., provider.updateCartQuantity(item.rowId!, currentQty - 1);
                    }
                  },
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '${item.quantity ?? 1}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  onPressed: () async {
                    final int currentQty =
                        int.tryParse(item.quantity?.toString() ?? '1') ?? 1;
                    final int stock =
                        int.tryParse(
                          item.availableStock?.toString() ?? '999',
                        ) ??
                        999;

                    if (currentQty < stock) {
                      await provider.incraseQty(
                        productId: item.id!,
                        context: context,
                      );
                      // Call your provider method here to increment quantity
                      // e.g., provider.updateCartQuantity(item.rowId!, currentQty + 1);
                    }
                  },
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Delete Button
          InkWell(
            onTap: () async {
              if (item.rowId == null) return;

              final CartResponse response = await provider.removeFromCart(
                item.rowId!,
              );

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(response.message ?? "Product removed"),
                    backgroundColor:
                        response.statusCode == 200 || response.status == "true"
                        ? Colors.green
                        : Colors.red,
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: const Color(0xFF1565C0),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 15 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  void _showChangeLocationDialog(BuildContext context) {
    final areaController = TextEditingController();
    final addressController = TextEditingController();
    final mobileController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Frame 1410117123',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Select Area Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Select Area',
                  ),
                  items: ['Dhaka', 'Chittagong', 'Sylhet', 'Rajshahi']
                      .map(
                        (area) =>
                            DropdownMenuItem(value: area, child: Text(area)),
                      )
                      .toList(),
                  onChanged: (value) {},
                ),
              ),

              const SizedBox(height: 12),

              // Address Field
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  hintText: 'Address',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Mobile Number Field
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Mobile Number',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Location updated'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartItem {
  String name;
  double price;
  int quantity;

  CartItem({required this.name, required this.price, required this.quantity});
}
