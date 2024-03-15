

class SavingsModel {
  String? id;
  String? customerName;
  int? billNo;
  int? savings;
  String? goodsName;
  int? totalCount;
  int? perPrice;
  int? totalPrice;

  SavingsModel({
    this.id,
    this.customerName,
    this.billNo,
    this.savings,
    this.goodsName,
    this.totalCount,
    this.perPrice,
    this.totalPrice

  });

  factory SavingsModel.fromJson(Map<String, dynamic> json) {
    return SavingsModel(
      id: json["id"],
      customerName: json["customerName"],
      billNo: json["billNo"],
      savings: json["savings"],
      goodsName: json["goodsName"],
      totalCount: json["totalCount"],
      perPrice: json["perPrice"],
      totalPrice: json["totalPrice"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["customerName"] = customerName;
    data["billNo"] = billNo;
    data["savings"] = savings;
    data["goodsName"]=goodsName;
    data["totalCount"]=totalCount;
    data["perPrice"]=perPrice;
    data["totalPrice"]=totalPrice;
    return data;
  }
}
