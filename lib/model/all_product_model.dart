class AllProductModel {
  bool? status;
  List<Data>? data;
  int? page;
  int? lastPage;
  int? statusCode;

  AllProductModel(
      {this.status, this.data, this.page, this.lastPage, this.statusCode});

  AllProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    page = json['page'];
    lastPage = json['last_page'];
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    data['last_page'] = this.lastPage;
    data['status_code'] = this.statusCode;
    return data;
  }
}

class Data {
  int? productSlNo;
  String? productCode;
  String? productName;
  int? productCategoryID;
  int? productsubCategoryID;
  int? supplierSlNo;
  int? color;
  int? brand;
  String? size;
  int? vat;
  int? discount;
  String? discountAmount;
  int? productReOrederLevel;
  String? productPurchaseRate;
  String? productSellingPrice;
  String? productMinimumSellingPrice;
  String? productWholesaleRate;
  String? oneCartunEqual;
  String? isService;
  int? unitID;
  String? imageName;
  String? note;
  String? status;
  String? addBy;
  String? addTime;
  String? updateBy;
  String? updateTime;
  int? productBranchid;
  int? currentStock;
  int? stock;
  int? productQuantity;
  String? productImage;

  Data(
      {this.productSlNo,
      this.productCode,
      this.productName,
      this.productCategoryID,
      this.productsubCategoryID,
      this.supplierSlNo,
      this.color,
      this.brand,
      this.size,
      this.vat,
      this.discount,
      this.discountAmount,
      this.productReOrederLevel,
      this.productPurchaseRate,
      this.productSellingPrice,
      this.productMinimumSellingPrice,
      this.productWholesaleRate,
      this.oneCartunEqual,
      this.isService,
      this.unitID,
      this.imageName,
      this.note,
      this.status,
      this.addBy,
      this.addTime,
      this.updateBy,
      this.updateTime,
      this.productBranchid,
      this.currentStock,
      this.stock,
      this.productQuantity,
      this.productImage});

  Data.fromJson(Map<String, dynamic> json) {
    productSlNo = json['Product_SlNo'];
    productCode = json['Product_Code'];
    productName = json['Product_Name'];
    productCategoryID = json['ProductCategory_ID'];
    productsubCategoryID = json['ProductsubCategory_ID'];
    supplierSlNo = json['Supplier_SlNo'];
    color = json['color'];
    brand = json['brand'];
    size = json['size'];
    vat = json['vat'];
    discount = json['discount'];
    discountAmount = json['discountAmount'];
    productReOrederLevel = json['Product_ReOrederLevel'];
    productPurchaseRate = json['Product_Purchase_Rate'];
    productSellingPrice = json['Product_SellingPrice'];
    productMinimumSellingPrice = json['Product_MinimumSellingPrice'];
    productWholesaleRate = json['Product_WholesaleRate'];
    oneCartunEqual = json['one_cartun_equal'];
    isService = json['is_service'];
    unitID = json['Unit_ID'];
    imageName = json['image_name'];
    note = json['note'];
    status = json['status'];
    addBy = json['AddBy'];
    addTime = json['AddTime'];
    updateBy = json['UpdateBy'];
    updateTime = json['UpdateTime'];
    productBranchid = json['Product_branchid'];
    currentStock = json['current_stock'];
    stock = json['stock'];
    productQuantity = json['product_quantity'];
    productImage = json['product_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Product_SlNo'] = this.productSlNo;
    data['Product_Code'] = this.productCode;
    data['Product_Name'] = this.productName;
    data['ProductCategory_ID'] = this.productCategoryID;
    data['ProductsubCategory_ID'] = this.productsubCategoryID;
    data['Supplier_SlNo'] = this.supplierSlNo;
    data['color'] = this.color;
    data['brand'] = this.brand;
    data['size'] = this.size;
    data['vat'] = this.vat;
    data['discount'] = this.discount;
    data['discountAmount'] = this.discountAmount;
    data['Product_ReOrederLevel'] = this.productReOrederLevel;
    data['Product_Purchase_Rate'] = this.productPurchaseRate;
    data['Product_SellingPrice'] = this.productSellingPrice;
    data['Product_MinimumSellingPrice'] = this.productMinimumSellingPrice;
    data['Product_WholesaleRate'] = this.productWholesaleRate;
    data['one_cartun_equal'] = this.oneCartunEqual;
    data['is_service'] = this.isService;
    data['Unit_ID'] = this.unitID;
    data['image_name'] = this.imageName;
    data['note'] = this.note;
    data['status'] = this.status;
    data['AddBy'] = this.addBy;
    data['AddTime'] = this.addTime;
    data['UpdateBy'] = this.updateBy;
    data['UpdateTime'] = this.updateTime;
    data['Product_branchid'] = this.productBranchid;
    data['current_stock'] = this.currentStock;
    data['stock'] = this.stock;
    data['product_quantity'] = this.productQuantity;
    data['product_image'] = this.productImage;
    return data;
  }
}
