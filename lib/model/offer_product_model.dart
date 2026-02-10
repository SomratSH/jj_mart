class OfferProductModel {
  final int slNo;
  final String name;
  final String sellingPrice;
  final String discountAmount;
  final double discountPercent;
  final String productImage;
  final int stock;
  final String purchasePrice;

  OfferProductModel({
    required this.slNo,
    required this.name,
    required this.sellingPrice,
    required this.discountAmount,
    required this.discountPercent,
    required this.productImage,
    required this.stock,
    required this.purchasePrice
  });

  factory OfferProductModel.fromJson(Map<String, dynamic> json) {
    return OfferProductModel(
      slNo: json['Product_SlNo'] ?? 0,
      name: json['Product_Name'] ?? '',
      sellingPrice: json['Product_SellingPrice'] ?? '0.00',
      discountAmount: json['discountAmount'] ?? '0.00',
      discountPercent: (json['discount'] is int)
          ? (json['discount'] as int).toDouble()
          : (json['discount'] ?? 0.0),
      productImage: json['product_image'] ?? '',
      stock: json['current_stock'] ?? 0,
      purchasePrice: json["Product_Purchase_Rate"]
    );
  }
}
