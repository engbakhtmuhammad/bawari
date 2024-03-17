import 'package:cloud_firestore/cloud_firestore.dart';

class SaleModel {
  String? id; // id
  String? customerName; // id
  String? customerId; // id
  int? billNo; // nill no
  String? name; // name
  String? note; // note
  int? goodsNo; // saman no
  int? pieceCount; // piece tadad
  int? cartonCount; // carton tadad
  int? perCartonCount; // fee carton tadad
  int? totalCount; // jumla tadad
  int? price; // qeemat
  DateTime? date;
  int? totalPrice;
  int? recievedCash;

  SaleModel(
      {this.id,
      this.goodsNo,
      this.cartonCount,
      this.perCartonCount,
      this.totalCount,
      this.price,
      this.billNo,
      this.name,
      this.note,
      this.pieceCount,
      this.date,
      this.totalPrice,
      this.customerId,
      this.customerName,
      this.recievedCash});

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json["id"],
      goodsNo: json["goodsNo"],
      cartonCount: json["cartonCount"],
      perCartonCount: json["perCartonCount"],
      totalCount: json["totalCount"],
      totalPrice: json["totalPrice"],
      price: json["price"],
      billNo: json["billNo"],
      name: json["name"],
      recievedCash: json["recievedCash"],
      pieceCount: json['pieceCount'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      note: json["note"],
      date: json["date"] != null ? (json["date"] as Timestamp).toDate() : null,
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
    data["recievedCash"] = recievedCash;
    data['pieceCount'] = pieceCount;
    data['customerId'] = customerId;
    data['customerName'] = customerName;
    data['totalPrice'] = totalPrice;
    data["note"] = note;
    data["date"] = date;
    return data;
  }
}
