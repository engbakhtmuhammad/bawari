import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/customer_model.dart';
import '../utils/colors.dart';

class CustomerController extends GetxController {
  TextEditingController customerNo = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();
  bool isActive = true;

  FirebaseFirestore db = FirebaseFirestore.instance;
  var customerList = RxList<CustomerModel>();
  int autoCustomerNo = 1;

  @override
  void onInit() async {
    await getCustomers();
    super.onInit();
  }

void addCustomer() async {
  try {
    var customer = CustomerModel(
      customerNo: int.parse(customerNo.text),
      price: int.tryParse(price.text) ?? 0,
      name: name.text,
      address: address.text,
      phone: phone.text,
      isActive: isActive,
    );

    DocumentReference documentReference =
        await db.collection("customers").add(customer.toJson());

    // Get the auto-generated ID
    String customerId = documentReference.id;

    // Update the customer model with the ID
    customer.id = customerId;

    await db
        .collection("customers")
        .doc(customerId) // Use the obtained ID
        .update({'id': customerId}); // Update the document with the ID field

    getCustomers();

    Get.snackbar('Success', 'Customer added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: primaryColor);

    // Increment autoCustomerNo
    autoCustomerNo++;

    customerNo.clear();
    price.clear();
    name.clear();
    address.clear();
    phone.clear();
    isActive = true;
    customerNo.text = autoCustomerNo.toString();
  } catch (e) {
    print('Error adding customer: $e');

    Get.snackbar('Error', 'Failed to add customer. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red);
  }
}


  Future<void> getCustomers() async {
    var customers = await db.collection("customers").get();
    customerList.clear();
    for (var customer in customers.docs) {
      customerList.add(CustomerModel.fromJson(customer.data()));
    }
    update();
    print("$customerList >>>>>>>. Customers List");
  }
  void deleteCustomer(String customerId) async {
    try {
      await db.collection("customers").doc(customerId).delete();
      print("Customer Deleted");

      Get.snackbar('Success', 'Customer deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: primaryColor);
    } catch (e) {
      print('Error deleting customer: $e');

      Get.snackbar('Error', 'Failed to delete customer. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red);
    }
    getCustomers();
    update();
  }
  List<String?> getCustomerNames() {
  return customerList.map((customer) => customer.name).toList();
}
String? getCustomerIdByName(String customerName) {
  for (var customer in customerList) {
    if (customer.name == customerName) {
      return customer.id; // Assuming `id` is the field representing the ID in CustomerModel
    }
  }
  return ''; // Return an empty string if no matching customer found
}

}
