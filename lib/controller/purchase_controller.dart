import 'package:bawari/model/purchase_model.dart';
import 'package:bawari/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

class PurchaseController extends GetxController {
  int autoBillNo = 1;
  TextEditingController bill = TextEditingController();
  TextEditingController date = TextEditingController(
      text: DateFormat('MM/dd/yyyy').format(DateTime.now()));
  TextEditingController name = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController goodsNo = TextEditingController();
  TextEditingController cartonCount = TextEditingController();
  TextEditingController perCartonCount = TextEditingController();
  TextEditingController totalCount = TextEditingController();
  TextEditingController price = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;
  var purchaseList = RxList<PurchaseModel>();

  @override
  void onInit() {
    bill.text = autoBillNo.toString(); // Assign autoBillNo to bill controller
    getPurchases();
    super.onInit();
  }

  void addPurchase() async {
    try {
      var purchase = PurchaseModel(
        name: name.text,
        note: note.text,
        goodsNo: int.tryParse(goodsNo.text) ?? 0,
        cartonCount: int.tryParse(cartonCount.text) ?? 0,
        perCartonCount: int.tryParse(perCartonCount.text) ?? 0,
        totalCount: int.tryParse(totalCount.text) ?? 0,
        price: int.tryParse(price.text) ?? 0,
        billNo: int.tryParse(bill.text) ?? 0,
        date: DateFormat('MM/dd/yyyy').parse(date.text),
      );

      await db.collection("purchases").add(purchase.toJson()).whenComplete(() {
        print("Purchase Added");
    
        getPurchases();

        // Show GetX Snackbar for success
        Get.snackbar('Success', 'Purchase added successfully!',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            backgroundColor: primaryColor);

        // Clear all controllers except date and bill
        name.clear();
        note.clear();
        goodsNo.clear();
        cartonCount.clear();
        perCartonCount.clear();
        totalCount.clear();
        price.clear();

        // Update bill controller value by adding 1
        autoBillNo++;
        bill.text = autoBillNo.toString();
      });
    } catch (e) {
      print('Error adding purchase: $e');

      // Show GetX Snackbar for error
      Get.snackbar('Error', 'Failed to add purchase. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red);
    }
  }

  void getPurchases() async {
    var purchases = await db.collection("purchases").get();
    purchaseList.clear();
    for (var purchase in purchases.docs) {
      purchaseList.add(PurchaseModel.fromJson(purchase.data()));
      
    }
    update();
    print("$purchaseList >>>>>>>. Purchases List");
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
}
