import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseModel {
  String? id;
  int? goodsNo;
  int? cartonCount;
  int? perCartonCount;
  int? totalCount;
  int? price;
  int? billNo;
  String? name;
  String? note;
  DateTime? date;
  DateTime? createdAt;
  DateTime? updatedAt;

  PurchaseModel({
    this.id,
    this.goodsNo,
    this.cartonCount,
    this.perCartonCount,
    this.totalCount,
    this.price,
    this.billNo,
    this.name,
    this.note,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      id: json["id"],
      goodsNo: json["goodsNo"],
      cartonCount: json["cartonCount"],
      perCartonCount: json["perCartonCount"],
      totalCount: json["totalCount"],
      price: json["price"],
      billNo: json["billNo"],
      name: json["name"],
      note: json["note"],
      date: json["date"] != null
          ? (json["date"] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["goodsNo"] = goodsNo;
    data["cartonCount"] = cartonCount;
    data["perCartonCount"] = perCartonCount;
    data["totalCount"] = totalCount;
    data["price"] = price;
    data["billNo"] = billNo;
    data["name"] = name;
    data["note"] = note;
    data["date"] = date;
    return data;
  }
}
