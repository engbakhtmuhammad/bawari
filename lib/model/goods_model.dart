

class GoodsModel {
  String? id;
  int? goodsNo;
  int? pieceCount;
  int? salePrice;
  int? purchasePrice;
  String? name;
  int? cartonCount;
  int? perCartonCount;
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
    this.isActive,
    this.pieceCount,
    this.perCartonCount,
  });

  factory GoodsModel.fromJson(Map<String, dynamic> json) {
    return GoodsModel(
      id: json["id"],
      goodsNo: json["goodsNo"],
      salePrice: json["salePrice"],
      purchasePrice: json["purchasePrice"],
      name: json["name"],
      cartonCount: json["cartonCount"],
      perCartonCount: json["perCartonCount"],
      pieceCount: json["pieceCount"],
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
    data["pieceCount"] = pieceCount;
    data["perCartonCount"] = perCartonCount;
    data["lineItem"] = lineItem;
    data["isActive"]=isActive;
    return data;
  }
}
