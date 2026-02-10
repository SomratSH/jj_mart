class CartItemModel {
  final int id;
  final String name;
  final int price;
  final int quantity;
  final String image;

  CartItemModel({required this.id, required this.name, required this.price, required this.quantity, required this.image});

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      image: json['image'],
    );
  }
}