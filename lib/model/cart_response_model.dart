class CartResponse {
  String? type;
  String? status;
  String? message;
  List<Cart>? cart;
  int? total;
  int? deliveryCharge;
  int? subTotal;
  int? quantity;

  CartResponse({
    this.type,
    this.status,
    this.message,
    this.cart,
    this.total,
    this.deliveryCharge,
    this.subTotal,
    this.quantity,
  });

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
    return data;
  }
}

class Cart {
  int? id;
  String? name;
  int? price;
  int? quantity;
  String? image;
  double? productQuantity;
  double? purchasePrice;
  int? discountAmount;
  String? rowId;

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

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    quantity = json['quantity'];
    image = json['image'];
    productQuantity = json['product_quantity'];
    purchasePrice = json['purchase_price'];
    discountAmount = json['discountAmount'];
    rowId = json['row_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['image'] = this.image;
    data['product_quantity'] = this.productQuantity;
    data['purchase_price'] = this.purchasePrice;
    data['discountAmount'] = this.discountAmount;
    data['row_id'] = this.rowId;
    return data;
  }
}
