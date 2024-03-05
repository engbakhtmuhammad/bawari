import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  String? id;
  int? billNo;
  int? price;
  String? expenseType;
  String? note;
  DateTime? date;

  ExpenseModel({
    this.id,
    this.billNo,
    this.price,
    this.expenseType,
    this.note,
    this.date,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json["id"],
      billNo: json["billNo"],
      price: json["price"],
      expenseType: json["expenseType"],
      note: json["note"],
      date: json["date"] != null
          ? (json["date"] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["billNo"] = billNo;
    data["price"] = price;
    data["expenseType"] = expenseType;
    data["note"] = note;
    data["date"] = date;
    return data;
  }
}
