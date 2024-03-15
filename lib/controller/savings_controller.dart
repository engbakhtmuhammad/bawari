import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/saving_model.dart';
import '../utils/colors.dart';

class SavingsController extends GetxController {
TextEditingController startDate = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController endDate = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime(2040, 3, 3)));
  FirebaseFirestore db = FirebaseFirestore.instance;
  var savingsList = RxList<SavingsModel>();

  @override
  void onInit() async {
    await getSavings();
    super.onInit();
  }

  void addSavings({required String customerName, required int billNo, required int savings, required String goodsName, required int totalCount, required int perPrice, required int totalPrice }) async {
    try {
      var saving = SavingsModel(
        customerName: customerName,
        billNo: billNo,
        savings: savings,
        goodsName: goodsName,
        totalCount: totalCount,
        perPrice: perPrice,
        totalPrice: totalPrice,
      );

      DocumentReference documentReference =
          await db.collection("savings").add(saving.toJson());

      // Get the auto-generated ID
      String savingsId = documentReference.id;

      // Update the savings model with the ID
      saving.id = savingsId;

      await db
          .collection("savings")
          .doc(savingsId) // Use the obtained ID
          .update({'id': savingsId}); // Update the document with the ID field

      getSavings();

      // Get.snackbar('Success', 'Savings added successfully!',
      //     snackPosition: SnackPosition.BOTTOM,
      //     duration: const Duration(seconds: 3),
      //     backgroundColor: primaryColor);
    } catch (e) {
      print('Error adding savings: $e');

      Get.snackbar('Error', 'Failed to add savings. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red);
    }
  }

  Future<void> getSavings() async {
    var savings = await db.collection("savings").get();
    savingsList.clear();
    for (var saving in savings.docs) {
      savingsList.add(SavingsModel.fromJson(saving.data()));
    }
    update();
    print("$savingsList >>>>>>>. Savings List");
  }

  void deleteSavings(String savingsId) async {
    try {
      await db.collection("savings").doc(savingsId).delete();
      print("Savings Deleted");

      Get.snackbar('Success', 'Savings deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: primaryColor);
    } catch (e) {
      print('Error deleting savings: $e');

      Get.snackbar('Error', 'Failed to delete savings. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red);
    }
    getSavings();
    update();
  }
}
