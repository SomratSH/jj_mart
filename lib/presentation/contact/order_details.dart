import 'package:flutter/material.dart';

class TrackOrderDetailsScreen extends StatefulWidget {
  const TrackOrderDetailsScreen({super.key});

  @override
  State<TrackOrderDetailsScreen> createState() => _TrackOrderDetailsScreenState();
}

class _TrackOrderDetailsScreenState extends State<TrackOrderDetailsScreen> {
  int _selectedIndex = 0;

  final List<OrderStatus> orderStatuses = [
    OrderStatus(
      date: '26, Sept',
      title: 'Order Placed',
      description: 'We have received your order',
      isCompleted: true,
    ),
    OrderStatus(
      date: '26, Sept',
      title: 'Confirm',
      description: 'Your order has been confirmed\nand is being processed',
      isCompleted: true,
    ),
    OrderStatus(
      date: '26, Sept',
      title: 'Packing',
      description: 'Your order is packaged and\nready to dispatch',
      isCompleted: true,
    ),
    OrderStatus(
      date: '',
      title: 'Shipping',
      description: 'Your order is on the way to\ndelivery location',
      isCompleted: false,
    ),
    OrderStatus(
      date: '',
      title: 'Delivered',
      description: 'Your order has been delivered',
      isCompleted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
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
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Timeline
                    _buildTimeline(),

                    const SizedBox(height: 24),

                    // Order Details Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Orange (1KG)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '৳ 350.00',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Order ID: #2315',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Address: House-4, Block-D, Basundhara R/A',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Number: 01712345670',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Processing',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: List.generate(orderStatuses.length, (index) {
        final status = orderStatuses[index];
        final isLast = index == orderStatuses.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Column
            SizedBox(
              width: 60,
              child: Text(
                status.date,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: status.isCompleted ? Colors.black87 : Colors.grey,
                ),
              ),
            ),

            // Timeline Indicator
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: status.isCompleted ? Colors.green : Colors.grey.shade300,
                  ),
                  child: status.isCompleted
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 60,
                    color: Colors.grey.shade300,
                  ),
              ],
            ),

            const SizedBox(width: 16),

            // Status Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: status.isCompleted ? Colors.black87 : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: status.isCompleted
                          ? Colors.grey.shade600
                          : Colors.grey.shade400,
                      height: 1.4,
                    ),
                  ),
                  if (!isLast) const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class OrderStatus {
  final String date;
  final String title;
  final String description;
  final bool isCompleted;

  OrderStatus({
    required this.date,
    required this.title,
    required this.description,
    required this.isCompleted,
  });
}

