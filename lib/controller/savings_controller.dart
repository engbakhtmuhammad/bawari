import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/saving_model.dart';
import '../utils/colors.dart';

class SavingsController extends GetxController {
  TextEditingController startDate = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController endDate = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController searchController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  var savingsList = RxList<SavingsModel>();
  var filteredSavingsList = RxList<SavingsModel>();

  @override
  void onInit() async {
    await getSavings();
    filterSavings();
    // Set up listeners for the text controllers
    startDate.addListener(filterSavings);
    endDate.addListener(filterSavings);
    searchController.addListener(filterSavings);
    super.onInit();
  }

  void addSavings({
    required String customerName,
    required int billNo,
    required int savings,
    required String goodsName,
    required int totalCount,
    required int perPrice,
    required int totalPrice,
  }) async {
    try {
      var saving = SavingsModel(
        customerName: customerName,
        billNo: billNo,
        savings: savings,
        goodsName: goodsName,
        totalCount: totalCount,
        perPrice: perPrice,
        totalPrice: totalPrice,
        date: DateFormat('yyyy-MM-dd').parse(startDate.text),
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

      Get.snackbar('Success', 'Savings added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3), colorText: whiteColor,
          backgroundColor: primaryColor);
    } catch (e) {
      print('Error adding savings: $e');

      Get.snackbar('Error', 'Failed to add savings. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3), colorText: whiteColor,
          backgroundColor: Colors.red);
    }
  }

  Future<void> getSavings() async {
    var savings = await db.collection("savings").get();
    savingsList.clear();

    for (var saving in savings.docs) {
      savingsList.add(SavingsModel.fromJson(saving.data()));
    }

    // Sort the list in descending order based on the billNo
    savingsList.sort((a, b) => b.billNo!.compareTo(a.billNo as num));

    filterSavings();
    update();
    print("$savingsList >>>>>>>. Savings List");
  }

  void filterSavings() {
    var query = searchController.text.toLowerCase();
    var tempList = savingsList;

    if (query.isNotEmpty) {
      tempList = tempList.where((saving) {
        return saving.customerName!.toLowerCase().contains(query);
      }).toList().obs;
    }

    filterSavingsByDateRange(tempList);
  }

  void filterSavingsByDateRange(RxList<SavingsModel> tempList) {
    print('>>>>>>>>> Start Date ${startDate.text}');
    print('>>>>>>>>> End Date ${endDate.text}');
    if (startDate.text.isEmpty || endDate.text.isEmpty) {
      filteredSavingsList.assignAll(tempList);
      return;
    }
    DateTime start = DateFormat('yyyy-MM-dd').parse(startDate.text);
    DateTime end = DateFormat('yyyy-MM-dd').parse(endDate.text);

    filteredSavingsList.assignAll(
      tempList.where(
        (saving) =>
            (saving.date!.isAfter(start) || saving.date!.isAtSameMomentAs(start)) &&
            (saving.date!.isBefore(end) || saving.date!.isAtSameMomentAs(end)),
      ).toList().obs,
    );
    print(">>>>>>>>>>>>>>>>>> $filteredSavingsList");
  }

  void deleteSavings(String savingsId) async {
    try {
      await db.collection("savings").doc(savingsId).delete();
      print("Savings Deleted");

      Get.snackbar('Success', 'Savings deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3), colorText: whiteColor,
          backgroundColor: primaryColor);
    } catch (e) {
      print('Error deleting savings: $e');

      Get.snackbar('Error', 'Failed to delete savings. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3), colorText: whiteColor,
          backgroundColor: Colors.red);
    }
    getSavings();
    update();
  }
}
