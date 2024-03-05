import 'package:cloud_firestore/cloud_firestore.dart';

class DuesModel {
  String? id;
  DateTime? date;
  String? customerId;
  String? customerName;
  int? dues;
  int? received;
  String? address;

  DuesModel({
     this.id,
     this.date,
     this.customerId,
     this.customerName,
     this.dues,
     this.received,
     this.address,
  });

  factory DuesModel.fromJson(Map<String, dynamic> json) {
    return DuesModel(
      id: json["id"] ?? "",
      customerId: json["customerId"] ?? "",
      customerName: json["customerName"] ?? "",
      dues: json["dues"]  ?? 0,
      received: json["received"]  ?? 0,
      address: json["address"] ?? "",
      date: json["date"] != null
          ? (json["date"] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "date": date,
      "customerId": customerId,
      "customerName": customerName,
      "dues": dues,
      "received": received,
      "address": address,
    };
  }
}
