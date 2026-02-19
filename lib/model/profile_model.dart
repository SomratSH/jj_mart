class ProfileModel {
  final int? customerSlNo;
  final String? customerCode;
  final String? customerName;
  final String? customerMobile;
  final String? customerEmail;
  final String? customerAddress;
  final String? customerImage;
  final String? points;
  final int? areaId;

  ProfileModel({
    this.customerSlNo,
    this.customerCode,
    this.customerName,
    this.customerMobile,
    this.customerEmail,
    this.customerAddress,
    this.customerImage,
    this.points,
    this.areaId,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      customerSlNo: json['Customer_SlNo'],
      customerCode: json['Customer_Code'],
      customerName: json['Customer_Name'],
      customerMobile: json['Customer_Mobile'],
      customerEmail: json['Customer_Email'],
      areaId: json["area_ID"],
      customerAddress: json['Customer_Address'],
      customerImage: json['customer_image'],
      points: json['point'].toString(),
    );
  }
}
