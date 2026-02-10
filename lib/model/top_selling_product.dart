class TopSellingProduct {
  final int slNo;
  final String code;
  final String name;
  final String sellingPrice;
  final String discountAmount;
  final String productImage;
  final double discount;
final String purchasePrice;
  TopSellingProduct({
    required this.slNo,
    required this.code,
    required this.name,
    required this.sellingPrice,
    required this.discountAmount,
    required this.productImage,
    required this.discount,
    required this.purchasePrice
  });

  factory TopSellingProduct.fromJson(Map<String, dynamic> json) {
    return TopSellingProduct(
      slNo: json['Product_SlNo'] ?? 0,
      code: json['Product_Code'] ?? '',
      name: json['Product_Name'] ?? '',
      sellingPrice: json['Product_SellingPrice'] ?? '0.00',
      discountAmount: json['discountAmount'] ?? '0.00',
      productImage: json['product_image'] ?? '',
      discount: (json['discount'] ?? 0).toDouble(),
      purchasePrice: json["Product_Purchase_Rate"]
      
    );
  }
}