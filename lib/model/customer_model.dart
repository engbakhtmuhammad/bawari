

class CustomerModel {
  String? id;
  int? customerNo;
  int? price;
  String? name;
  String? address;
  String? phone;
  bool? isActive;

  CustomerModel({
    this.id,
    this.customerNo,
    this.price,
    this.name,
    this.address,
    this.phone,
    this.isActive
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json["id"],
      customerNo: json["customerNo"],
      price: json["price"],
      name: json["name"],
      address: json["address"],
      phone: json["phone"],
      isActive: json["isActive"]
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["customerNo"] = customerNo;
    data["price"] = price;
    data["name"] = name;
    data["address"] = address;
    data["phone"] = phone;
    data["isActive"]=isActive;
    return data;
  }
}
