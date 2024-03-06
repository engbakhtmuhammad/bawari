import 'package:cloud_firestore/cloud_firestore.dart';

class DuesModel {
  String? id;
  DateTime? date;
  String? customerId;
  String? customerName;
  int? dues;
  int? received;
  String? address;
  List<DuesModel>? subDuesList; // New field

  DuesModel({
    this.id,
    this.date,
    this.customerId,
    this.customerName,
    this.dues,
    this.received,
    this.address,
    this.subDuesList,
  });

  factory DuesModel.fromJson(Map<String, dynamic> json) {
    return DuesModel(
      id: json["id"] ?? "",
      customerId: json["customerId"] ?? "",
      customerName: json["customerName"] ?? "",
      dues: json["dues"] ?? 0,
      received: json["received"] ?? 0,
      address: json["address"] ?? "",
      date: json["date"] != null
          ? (json["date"] as Timestamp).toDate()
          : null,
      subDuesList: (json["subDuesList"] as List<dynamic>?)
          ?.map((subDuesJson) =>
              DuesModel.fromJson(subDuesJson as Map<String, dynamic>))
          .toList(),
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
      "subDuesList": subDuesList?.map((subDues) => subDues.toJson()).toList(),
    };
  }
}
