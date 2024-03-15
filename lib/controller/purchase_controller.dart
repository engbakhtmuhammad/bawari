import 'package:bawari/model/purchase_model.dart';
import 'package:bawari/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

import '../utils/common.dart';

class PurchaseController extends GetxController {
  TextEditingController bill = TextEditingController();
  TextEditingController startDate = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController endDate = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime(2040, 3, 3)));
  TextEditingController date = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  String name = "";
  TextEditingController note = TextEditingController();
  TextEditingController goodsNo = TextEditingController();
  TextEditingController cartonCount = TextEditingController();
  TextEditingController perCartonCount = TextEditingController();
  TextEditingController totalCount = TextEditingController();
  TextEditingController price = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;
  var purchaseList = RxList<PurchaseModel>();

  @override
  void onInit() async {
    bill.text = autoBillNo.toString(); // Assign autoBillNo to the bill controller
    await getPurchases();
    getTotalBill();
    getTotalCartonCount();
    getTotalPrice();
    getPurchasesBetweenDates();
    super.onInit();
  }

  void addPurchase() async {
    try {
      var purchase = PurchaseModel(
        id: null, // Initially set to null, will be updated after adding to Firestore
        name: name,
        note: note.text,
        goodsNo: int.tryParse(goodsNo.text) ?? 0,
        cartonCount: int.tryParse(cartonCount.text) ?? 0,
        perCartonCount: int.tryParse(perCartonCount.text) ?? 0,
        totalCount: int.tryParse(totalCount.text) ?? 0,
        price: int.tryParse(price.text) ?? 0,
        billNo: int.tryParse(bill.text) ?? 0,
        date: DateFormat('yyyy-MM-dd').parse(date.text),
      );

      DocumentReference documentReference =
          await db.collection("purchases").add(purchase.toJson());

      // Get the auto-generated ID
      String purchaseId = documentReference.id;

      // Update the purchase model with the ID
      purchase.id = purchaseId;

      await db
          .collection("purchases")
          .doc(purchaseId) // Use the obtained ID
          .update({'id': purchaseId}); // Update the document with the ID field

      await getPurchases();

      // Show GetX Snackbar for success
      Get.snackbar('Success', 'Purchase added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: primaryColor);

      // Clear all controllers except date and bill
      name='';
      note.clear();
      goodsNo.clear();
      cartonCount.clear();
      perCartonCount.clear();
      totalCount.clear();
      price.clear();

      // Update bill controller value by adding 1
      autoBillNo+10;
      bill.text = autoBillNo.toString();
    } catch (e) {
      print('Error adding purchase: $e');

      // Show GetX Snackbar for error
      Get.snackbar('Error', 'Failed to add purchase. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red);
    }
  }

  Future<void> getPurchases() async {
    var purchases = await db.collection("purchases").get();
    purchaseList.clear();
    for (var purchase in purchases.docs) {
      purchaseList.add(PurchaseModel.fromJson(purchase.data()));
    }
    update();
    print("$purchaseList >>>>>>>. Purchases List");
  }
   PurchaseModel? getPurchaseByBill(String bill) {
    for (var purchase in purchaseList) {
      if (purchase.billNo == bill) {
        return purchase;
      }
    }
    return null; // Return null if no matching customer found
  }

  int getTotalBill() {
    return purchaseList.fold(0, (sum, purchase) => sum + purchase.billNo!);
  }

  int getTotalCartonCount() {
    return purchaseList.fold(0, (sum, purchase) => sum + purchase.cartonCount!);
  }

  int getTotalPrice() {
    return purchaseList.fold(0, (sum, purchase) => sum + purchase.price!);
  }

  List<PurchaseModel> getPurchasesBetweenDates() {
    return purchaseList
        .where((purchase) =>
            purchase.date!
                .isAfter(DateFormat('yyyy-MM-dd').parse(startDate.text)) &&
            purchase.date!
                .isBefore(DateFormat('yyyy-MM-dd').parse(endDate.text)))
        .toList();
  }
}
