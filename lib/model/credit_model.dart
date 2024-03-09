import 'package:cloud_firestore/cloud_firestore.dart';

class CreditModel {
  String? id;
  String? customerId;
  String? customerName;
  List<Credit>? credits;
  List<Credit>? received;

  CreditModel(
      {this.id,
      this.customerId,
      this.customerName,
      this.credits,
      this.received});

CreditModel.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  customerId = json['customerId'];
  customerName = json['customerName'];
  
  if (json['credits'] != null) {
    if (json['credits'] is List) {
      credits = <Credit>[];
      json['credits'].forEach((v) {
        credits!.add(new Credit.fromJson(v));
      });
    } else {
    }
  }
  
  if (json['received'] != null) {
    if (json['received'] is List) {
      received = <Credit>[];
      json['received'].forEach((v) {
        received!.add(new Credit.fromJson(v));
      });
    } else {
    }
  }
}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    data['customerName'] = this.customerName;
    if (this.credits != null) {
      data['credits'] = this.credits!.map((v) => v.toJson()).toList();
    }
    if (this.received != null) {
      data['received'] = this.received!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Credit {
  int? price;
  DateTime? date;
  String? address;
  int? billNo;

  Credit({this.price, this.date, this.address,this.billNo});

  Credit.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    billNo = json['billNo'];
    date = json["date"] != null
          ? (json["date"] as Timestamp).toDate()
          : null;
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['billNo'] = this.billNo;
    data['date'] = this.date;
    data['address'] = this.address;
    return data;
  }
}
