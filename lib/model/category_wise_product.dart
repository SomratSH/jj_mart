class CategoryWiseProductModel {
  final int? id;
  final String? name;
  final String? productImage;
  final String? sellingPrice;
  final String? discountAmount;
  final int? categoryId;

  CategoryWiseProductModel({
    this.id,
    this.name,
    this.productImage,
    this.sellingPrice,
    this.discountAmount,
    this.categoryId,
  });

  factory CategoryWiseProductModel.fromJson(Map<String, dynamic> json) {
    return CategoryWiseProductModel(
      id: json['Product_SlNo'],
      name: json['Product_Name'],
      productImage: json['product_image'],
      sellingPrice: json['Product_SellingPrice'].toString(),
      discountAmount: json['discountAmount'].toString(),
      categoryId: json['ProductCategory_ID'],
    );
  }
}
