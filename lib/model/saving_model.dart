

import 'package:cloud_firestore/cloud_firestore.dart';

class SavingsModel {
  String? id;
  String? customerName;
  int? billNo;
  int? savings;
  String? goodsName;
  int? totalCount;
  int? perPrice;
  int? totalPrice;
  DateTime? date;

  SavingsModel({
    this.id,
    this.customerName,
    this.billNo,
    this.savings,
    this.goodsName,
    this.totalCount,
    this.perPrice,
    this.totalPrice,
    this.date

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
      date: json["date"] != null
          ? (json["date"] as Timestamp).toDate()
          : null,
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
    data["date"]=date;
    return data;
  }
}
