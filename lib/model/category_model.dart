class CategoryModel {
  final int? id;
  final String? name;
  final String? image;

  CategoryModel({this.id, this.name, this.image});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['ProductCategory_SlNo'],
      name: json['ProductCategory_Name'],
      image: json['ProductCategory_Image'],
    );
  }
}
