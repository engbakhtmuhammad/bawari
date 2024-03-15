

class CustomerModel {
  String? id;
  String? name;
  String? address;
  String? phone;
  bool? isActive;

  CustomerModel({
    this.id,
    this.name,
    this.address,
    this.phone,
    this.isActive
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      phone: json["phone"],
      isActive: json["isActive"]
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["name"] = name;
    data["address"] = address;
    data["phone"] = phone;
    data["isActive"]=isActive;
    return data;
  }
}
