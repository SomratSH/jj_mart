class CartResponse {
  final String? type;
  final String? status;
  final String? message;
  final List<Cart>? cart;
  final double? total;
  final double? deliveryCharge;
  final double? subTotal;
  final int? totalQuantity;

  CartResponse({
    this.type,
    this.status,
    this.message,
    this.cart,
    this.total,
    this.deliveryCharge,
    this.subTotal,
    this.totalQuantity,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      type: json['type'],
      status: json['status'],
      message: json['message'],
      // Safely parse the list of items
      cart: json['cart'] != null
          ? List<Cart>.from(json['cart'].map((x) => Cart.fromJson(x)))
          : null,
      // Using .toDouble() on a num is the safest way to handle int vs double errors
      total: (json['total'] as num?)?.toDouble(),
      deliveryCharge: (json['delivery_charge'] as num?)?.toDouble(),
      subTotal: (json['sub_total'] as num?)?.toDouble(),
      totalQuantity: json['quantity'] as int?,
    );
  }
}

class Cart {
  final int? id;
  final String? name;
  final double? price;
  final int? quantity;
  final String? image;
  final int? productQuantity;
  final double? purchasePrice;
  final double? discountAmount;
  final String? rowId;

  Cart({
    this.id,
    this.name,
    this.price,
    this.quantity,
    this.image,
    this.productQuantity,
    this.purchasePrice,
    this.discountAmount,
    this.rowId,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] as int?,
      name: json['name'],
      // Handles cases like price: 9.2
      price: (json['price'] as num?)?.toDouble(),
      quantity: json['quantity'] as int?,
      image: json['image'],
      productQuantity: json['product_quantity'] as int?,
      purchasePrice: (json['purchase_price'] as num?)?.toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      rowId: json['row_id'],
    );
  }
}
