// class CartResponse {
//   final String? type;
//   final String? status;
//   final String? message;
//   final List<Cart>? cart;
//   final double? total;
//   final dynamic deliveryCharge;
//   final double? subTotal;
//   final dynamic totalQuantity;

//   CartResponse({
//     this.type,
//     this.status,
//     this.message,
//     this.cart,
//     this.total,
//     this.deliveryCharge,
//     this.subTotal,
//     this.totalQuantity,
//   });

//   factory CartResponse.fromJson(Map<String, dynamic> json) {
//     return CartResponse(
//       type: json['type'],
//       status: json['status'],
//       message: json['message'],
//       // Safely parse the list of items
//       cart: json['cart'] != null
//           ? List<Cart>.from(json['cart'].map((x) => Cart.fromJson(x)))
//           : null,
//       // Using .toDouble() on a num is the safest way to handle int vs double errors
//       total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
//       deliveryCharge: json['delivery_charge'],
//       subTotal:double.tryParse(json['sub_total']?.toString() ?? '0') ?? 0.0,
//       totalQuantity: json['quantity'],
//     );
//   }
// }

// class Cart {
//   final int? id;
//   final String? name;
//   final dynamic? price;
//   final dynamic quantity;
//   final String? image;
//   final dynamic? productQuantity;
//   final dynamic? purchasePrice;
//   final dynamic? discountAmount;
//   final String? rowId;

//   Cart({
//     this.id,
//     this.name,
//     this.price,
//     this.quantity,
//     this.image,
//     this.productQuantity,
//     this.purchasePrice,
//     this.discountAmount,
//     this.rowId,
//   });

//   factory Cart.fromJson(Map<String, dynamic> json) {
//     return Cart(
//       id: json['id'] as int?,
//       name: json['name'],
//       // Handles cases like price: 9.2
//       price: json['price'],
//       quantity: json['quantity'],
//       image: json['image'],
//       productQuantity: json['product_quantity'],
//       purchasePrice: json['purchase_price'],
//       discountAmount: json['discountAmount'],
//       rowId: json['row_id'],
//     );
//   }
// }
class CartResponse {
  String? type;
  String? status;
  String? message;
  List<Cart>? cart;
  int? total;
  int? deliveryCharge;
  int? subTotal;
  int? quantity;
  int? statusCode;

  CartResponse(
      {this.type,
      this.status,
      this.message,
      this.cart,
      this.total,
      this.deliveryCharge,
      this.subTotal,
      this.quantity,
      this.statusCode});

  CartResponse.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    status = json['status'];
    message = json['message'];
    if (json['cart'] != null) {
      cart = <Cart>[];
      json['cart'].forEach((v) {
        cart!.add(new Cart.fromJson(v));
      });
    }
    total = json['total'];
    deliveryCharge = json['delivery_charge'];
    subTotal = json['sub_total'];
    quantity = json['quantity'];
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.cart != null) {
      data['cart'] = this.cart!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['delivery_charge'] = this.deliveryCharge;
    data['sub_total'] = this.subTotal;
    data['quantity'] = this.quantity;
    data['status_code'] = this.statusCode;
    return data;
  }
}

class Cart {
  int? id;
  String? name;
  dynamic? price;
  dynamic? quantity;
  String? image;
  dynamic? discountAmount;
  dynamic? availableStock;
  String? rowId;

  Cart(
      {this.id,
      this.name,
      this.price,
      this.quantity,
      this.image,
      this.discountAmount,
      this.availableStock,
      this.rowId});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    quantity = json['quantity'];
    image = json['image'];
    discountAmount = json['discountAmount'];
    availableStock = json['available_stock'];
    rowId = json['row_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['image'] = this.image;
    data['discountAmount'] = this.discountAmount;
    data['available_stock'] = this.availableStock;
    data['row_id'] = this.rowId;
    return data;
  }
}
