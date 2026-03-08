class AreaModel {
  final int id;
  final String name;
  final double deliveryCharge;
  final int specialDiscount;

  AreaModel({
    required this.id,
    required this.name,
    required this.deliveryCharge,
    required this.specialDiscount,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['District_SlNo'] ?? 0,
      name: json['District_Name'] ?? '',
      // Safe parsing for int/double/string
      deliveryCharge: double.tryParse(json['delivery_charge']?.toString() ?? '0') ?? 0.0,
      specialDiscount: json['special_discount'] ?? 0,
    );
  }
}