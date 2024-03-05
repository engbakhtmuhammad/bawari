

class GoodsModel {
  String? id;
  int? goodsNo;
  int? salePrice;
  int? purchasePrice;
  String? name;
  int? cartonCount;
  bool? isActive;
  bool? lineItem;

  GoodsModel({
    this.id,
    this.goodsNo,
    this.salePrice,
    this.purchasePrice,
    this.name,
    this.cartonCount,
    this.lineItem,
    this.isActive
  });

  factory GoodsModel.fromJson(Map<String, dynamic> json) {
    return GoodsModel(
      id: json["id"],
      goodsNo: json["goodsNo"],
      salePrice: json["salePrice"],
      purchasePrice: json["purchasePrice"],
      name: json["name"],
      cartonCount: json["cartonCount"],
      lineItem: json["lineItem"],
      isActive: json["isActive"]
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["goodsNo"] = goodsNo;
    data["salePrice"] = salePrice;
    data["purchasePrice"] = purchasePrice;
    data["name"] = name;
    data["cartonCount"] = cartonCount;
    data["lineItem"] = lineItem;
    data["isActive"]=isActive;
    return data;
  }
}
