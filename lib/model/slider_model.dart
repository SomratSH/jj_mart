class SliderModel {
  final int id;
  final String title;
  final String productImage;

  SliderModel({
    required this.id,
    required this.title,
    required this.productImage,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      productImage: json['product_image'] ?? '',
    );
  }
}
