class CartResponse {
  final String? type;
  final String? status;
  final String? message;
  final List<Cart>? cart;
  final double? total;
  final dynamic deliveryCharge;
  final double? subTotal;
  final dynamic totalQuantity;

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
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      deliveryCharge: json['delivery_charge'],
      subTotal:double.tryParse(json['sub_total']?.toString() ?? '0') ?? 0.0,
      totalQuantity: json['quantity'],
    );
  }
}

class Cart {
  final int? id;
  final String? name;
  final dynamic? price;
  final dynamic quantity;
  final String? image;
  final dynamic? productQuantity;
  final dynamic? purchasePrice;
  final dynamic? discountAmount;
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
      price: json['price'],
      quantity: json['quantity'],
      image: json['image'],
      productQuantity: json['product_quantity'],
      purchasePrice: json['purchase_price'],
      discountAmount: json['discountAmount'],
      rowId: json['row_id'],
    );
  }
}
