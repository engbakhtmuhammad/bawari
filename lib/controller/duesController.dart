import 'package:bawari/model/duesModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';

class DuesController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  var duesList = RxList<DuesModel>();

  TextEditingController date = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  TextEditingController customerId = TextEditingController();
  String customerName = "گراک نوم";
  TextEditingController address = TextEditingController();
  TextEditingController dues = TextEditingController();
  TextEditingController received = TextEditingController();

  @override
  void onInit() async {
    await getDuesEntries();
    super.onInit();
  }

  Future<void> addDuesEntry() async {
    try {

      var duesEntry = DuesModel(
        customerId: customerId.text,
        customerName: customerName,
        dues: [Dues(price: int.parse(dues.text),date: DateFormat('yyyy-MM-dd').parse(date.text),address: address.text)],
        received: [],
      );

      DocumentReference documentReference =
          await db.collection("dues").add(duesEntry.toJson());

      // Get the auto-generated ID
      String duesId = documentReference.id;

      // Update the dues model with the ID
      duesEntry.id = duesId;

      await db.collection("dues").doc(duesId).update({'id': duesId});

      getDuesEntries();
      Get.snackbar('Success', 'Dues added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: primaryColor);

      // Clear the text editing controllers after adding the entry
      date.clear();
      customerId.clear();
      customerName = "";
      dues.clear();
      received.clear();
      address.clear();
    } catch (e) {
      print('Error adding dues entry: $e');
      // Handle the error
    }
    update();
  }

  Future<void> getDuesEntries() async {
    
    var duesEntries =
        await db.collection("dues").orderBy("date", descending: true).get();
    duesList.clear();
    for (var duesEntry in duesEntries.docs) {
      duesList.add(DuesModel.fromJson(duesEntry.data()));
    }
    update();
    print("$duesList >>>>>>>. Dues Entries List");
  }

  DuesModel? getCustomerByName(String name) {
    for (var customer in duesList) {
      if (customer.customerName == name) {
        return customer;
      }
    }
    return null; // Return null if no matching customer found
  }
   DuesModel? getDuesByName(String name) {
    for (var dues in duesList) {
      if (dues.customerName == name) {
        return dues;
      }
    }
    return null; // Return null if no matching customer found
  }

  // void addToSubDueList(String docId,) {
  //   try {
  //     var collection = FirebaseFirestore.instance.collection('dues');
  //     collection
  //         .doc(docId)
  //         .update({
  //           'dues': FieldValue.arrayUnion([subDue.toJson()])
  //         })
  //         .then((_) {
  //           getDuesEntries();
  //           Get.snackbar('Success', 'Dues added successfully!',
  //               snackPosition: SnackPosition.BOTTOM,
  //               duration: const Duration(seconds: 3),
  //               backgroundColor: Colors.green);
  //         })
  //         .catchError((error) {
  //           Get.snackbar('Failed', error,
  //               snackPosition: SnackPosition.BOTTOM,
  //               duration: const Duration(seconds: 3),
  //               backgroundColor: Colors.red);
  //         });
  //   } catch (e) {
  //     print('Error adding dues entry: $e');
  //     // Handle the error
  //   }
  //   update();
  // }
}