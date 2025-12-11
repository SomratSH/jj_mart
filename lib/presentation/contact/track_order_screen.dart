import 'package:flutter/material.dart';
import 'package:jj_mart/presentation/contact/order_details.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  String selectedFilter = 'All Order';

  final List<OrderItem> orders = [
    OrderItem(
      productName: 'Pineapple (1KG)',
      price: '৳ 350.00',
      orderId: 'ID #2315',
      address: 'Address: House-4, Block-D, Basundhara R/A',
      phone: 'Number: 01712345670',
      status: 'Delivered',
      statusColor: Colors.green,
      backgroundColor: Colors.white,
      date: '28 Sept, 10:35',
    ),
    OrderItem(
      productName: 'Orange (1KG)',
      price: '৳ 350.00',
      orderId: 'ID #2315',
      address: 'Address: House-4, Block-D, Basundhara R/A',
      phone: 'Number: 01712345670',
      status: 'Processing',
      statusColor: Colors.blue,
      backgroundColor: const Color(0xFF1565C0),
      date: '',
    ),
    OrderItem(
      productName: 'Pineapple (1KG)',
      price: '৳ 350.00',
      orderId: 'ID #2315',
      address: 'Address: House-4, Block-D, Basundhara R/A',
      phone: 'Number: 01712345670',
      status: 'Delivered',
      statusColor: Colors.green,
      backgroundColor: Colors.white,
      date: '28 Sept, 10:35',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Order',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Buttons
          Container(
            color: const Color(0xFF1565C0),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                _buildFilterButton('All Order'),
                const SizedBox(width: 8),
                _buildFilterButton('Pending'),
                const SizedBox(width: 8),
                _buildFilterButton('Processing'),
                const SizedBox(width: 8),
                _buildFilterButton('Delivered'),
              ],
            ),
          ),

          // Order List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>TrackOrderDetailsScreen ()));
                    },
                    child: _buildOrderCard(orders[index])),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String title) {
    final isSelected = selectedFilter == title;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderItem order) {
    final isWhiteCard = order.backgroundColor == Colors.white;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: order.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name and Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.productName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isWhiteCard ? Colors.black87 : Colors.white,
                ),
              ),
              if (order.date.isNotEmpty)
                Text(
                  order.date,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            order.price,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isWhiteCard ? Colors.black87 : Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          // Order ID
          Text(
            'Order: ${order.orderId}',
            style: TextStyle(
              fontSize: 13,
              color: isWhiteCard ? Colors.black87 : Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          // Address
          Text(
            order.address,
            style: TextStyle(
              fontSize: 13,
              color: isWhiteCard ? Colors.black87 : Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          // Phone Number
          Text(
            order.phone,
            style: TextStyle(
              fontSize: 13,
              color: isWhiteCard ? Colors.black87 : Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          // Status Button
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: order.statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                order.status,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderItem {
  final String productName;
  final String price;
  final String orderId;
  final String address;
  final String phone;
  final String status;
  final Color statusColor;
  final Color backgroundColor;
  final String date;

  OrderItem({
    required this.productName,
    required this.price,
    required this.orderId,
    required this.address,
    required this.phone,
    required this.status,
    required this.statusColor,
    required this.backgroundColor,
    required this.date,
  });
}


