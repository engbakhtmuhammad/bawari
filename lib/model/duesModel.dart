import 'package:cloud_firestore/cloud_firestore.dart';

class DuesModel {
  String? id;
  String? customerId;
  String? customerName;
  List<Dues>? dues;
  List<Received>? received;

  DuesModel(
      {this.id,
      this.customerId,
      this.customerName,
      this.dues,
      this.received});

DuesModel.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  customerId = json['customerId'];
  customerName = json['customerName'];
  
  if (json['dues'] != null) {
    if (json['dues'] is List) {
      dues = <Dues>[];
      json['dues'].forEach((v) {
        dues!.add(new Dues.fromJson(v));
      });
    } else {
      // Handle the case where 'dues' is not a List
      // You can add custom logic here based on your requirements
    }
  }
  
  if (json['received'] != null) {
    if (json['received'] is List) {
      received = <Received>[];
      json['received'].forEach((v) {
        received!.add(new Received.fromJson(v));
      });
    } else {
      // Handle the case where 'received' is not a List
      // You can add custom logic here based on your requirements
    }
  }
}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    data['customerName'] = this.customerName;
    if (this.dues != null) {
      data['dues'] = this.dues!.map((v) => v.toJson()).toList();
    }
    if (this.received != null) {
      data['received'] = this.received!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dues {
  int? price;
  DateTime? date;
  String? address;

  Dues({this.price, this.date, this.address});

  Dues.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    date = json["date"] != null
          ? (json["date"] as Timestamp).toDate()
          : null;
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['date'] = this.date;
    data['address'] = this.address;
    return data;
  }
}
class Received {
  int? price;
  DateTime? date;
  String? address;

  Received({this.price, this.date, this.address});

  Received.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    date = json["date"] != null
          ? (json["date"] as Timestamp).toDate()
          : null;
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['date'] = this.date;
    data['address'] = this.address;
    return data;
  }
}

