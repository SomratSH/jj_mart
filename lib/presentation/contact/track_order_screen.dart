import 'package:flutter/material.dart';
import 'package:jj_mart/model/profile_model.dart';
import 'package:jj_mart/presentation/contact/order_details.dart';
import 'package:flutter/material.dart';
import 'package:jj_mart/provider/profile_provider/profile_provider.dart';
import 'package:provider/provider.dart';
// Import your provider and model here

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  String selectedFilter = 'All Order';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Replace 'CartProvider' with your actual provider name
      context.read<ProfileProvider>().fetchUserSales();
    });
  }

  // Maps API status codes to UI labels and colors
  Map<String, dynamic> getStatusUI(String status) {
    switch (status) {
      case 'p':
        return {
          'label': 'Pending',
          'color': Colors.orange,
          'filter': 'Pending',
        };
      case 'a':
        return {
          'label': 'Confirmed',
          'color': Colors.green,
          'filter': 'Confirmed',
        };
      case 'c':
        return {
          'label': 'Cancelled',
          'color': Colors.red,
          'filter': 'Cancelled',
        };
      default:
        return {
          'label': 'Delivered',
          'color': Colors.green,
          'filter': 'Delivered',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>(); // Use your provider name

    // Filtering logic
    final filteredOrders = provider.salesList.where((order) {
      if (selectedFilter == 'All Order') return true;
      return getStatusUI(order.status)['filter'] == selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        title: const Text('My Orders', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            color: const Color(0xFF1565C0),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                _buildFilterButton('All Order'),
                const SizedBox(width: 4),
                _buildFilterButton('Pending'),
                const SizedBox(width: 4),
                _buildFilterButton('Cancel'),
                const SizedBox(width: 4),
                _buildFilterButton('Delivered'),
              ],
            ),
          ),

          // List Area
          Expanded(
            child: provider.isLoadingSales
                ? const Center(child: CircularProgressIndicator())
                : filteredOrders.isEmpty
                ? const Center(child: Text("No orders found"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      return _buildOrderCard(filteredOrders[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String title) {
    bool isSelected = selectedFilter == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedFilter = title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(UserSale order) {
    final statusData = getStatusUI(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Invoice: ${order.invoiceNo}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                order.saleDate,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          const Divider(height: 20),
          Text(
            "Amount: ৳ ${order.total.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Color(0xFF1565C0),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _rowInfo(Icons.person, "Customer: ${order.shippingName}"),
          _rowInfo(Icons.location_on, "Address: ${order.shippingAddress}"),
          _rowInfo(Icons.phone, "Phone: ${order.shippingPhone}"),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusData['color'],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusData['label'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class UserSale {
  final int id;
  final String invoiceNo;
  final String saleDate;
  final String? description;
  final double subTotal;
  final double discount;
  final double total;
  final double due;
  final String status;
  final String shippingName;
  final String shippingPhone;
  final String shippingAddress;

  UserSale({
    required this.id,
    required this.invoiceNo,
    required this.saleDate,
    this.description,
    required this.subTotal,
    required this.discount,
    required this.total,
    required this.due,
    required this.status,
    required this.shippingName,
    required this.shippingPhone,
    required this.shippingAddress,
  });

  factory UserSale.fromJson(Map<String, dynamic> json) {
    return UserSale(
      id: json['SaleMaster_SlNo'],
      invoiceNo: json['SaleMaster_InvoiceNo'] ?? '',
      saleDate: json['SaleMaster_SaleDate'] ?? '',
      description: json['SaleMaster_Description'],
      subTotal:
          double.tryParse(
            json['SaleMaster_SubTotalAmount']?.toString() ?? '0',
          ) ??
          0.0,
      discount:
          double.tryParse(
            json['SaleMaster_TotalDiscountAmount']?.toString() ?? '0',
          ) ??
          0.0,
      total:
          double.tryParse(
            json['SaleMaster_TotalSaleAmount']?.toString() ?? '0',
          ) ??
          0.0,
      due:
          double.tryParse(json['SaleMaster_DueAmount']?.toString() ?? '0') ??
          0.0,
      status:
          json['Status'] ??
          'p', // p = pending, a = approved, c = cancelled, etc.
      shippingName: json['ShippingName'] ?? 'N/A',
      shippingPhone: json['ShippingPhone'] ?? 'N/A',
      shippingAddress: json['ShippingAddress'] ?? 'N/A',
    );
  }
}
