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
    // Check if the customer name already exists
    var existingCustomer = duesList.firstWhere(
      (entry) => entry.customerName == customerName,
      orElse: () => DuesModel(), // Provide a default value (empty DuesModel)
    );

    if (existingCustomer.id != null) {
      // If customer name exists, update the existing entry
      existingCustomer.dues!.add(
        Dues(
          price: int.parse(dues.text),
          date: DateFormat('yyyy-MM-dd').parse(date.text),
          address: address.text,
        ),
      );

      // Update the existing document in Firestore
      await db.collection("dues").doc(existingCustomer.id!).update({
        'dues': existingCustomer.dues!.map((d) => d.toJson()).toList(),
      });

      Get.snackbar('Success', 'Dues updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: primaryColor);
    } else {
      // If customer name doesn't exist, add a new entry
      var duesEntry = DuesModel(
        customerId: customerId.text,
        customerName: customerName,
        dues: [
          Dues(
            price: int.parse(dues.text),
            date: DateFormat('yyyy-MM-dd').parse(date.text),
            address: address.text,
          ),
        ],
        received: [],
      );

      DocumentReference documentReference =
          await db.collection("dues").add(duesEntry.toJson());

      // Get the auto-generated ID
      String duesId = documentReference.id;

      // Update the dues model with the ID
      duesEntry.id = duesId;

      await db.collection("dues").doc(duesId).update({'id': duesId});

      Get.snackbar('Success', 'Dues added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: primaryColor);
    }

    // Clear the text editing controllers after adding/updating the entry
    customerId.clear();
    customerName = "";
    dues.clear();
    received.clear();
    address.clear();
  } catch (e) {
    print('Error adding/updating dues entry: $e');
    // Handle the error
  }
  update();
}

Future<void> addRecieveEntry() async {
  try {
    // Check if the customer name already exists
    var existingCustomer = duesList.firstWhere(
      (entry) => entry.customerName == customerName,
      orElse: () => DuesModel(), // Provide a default value (empty DuesModel)
    );

    if (existingCustomer.id != null) {
      // If customer name exists, update the existing entry
      existingCustomer.received!.add(
        Dues(
          price: int.parse("-${received.text}"),
          date: DateFormat('yyyy-MM-dd').parse(date.text),
          address: address.text,
        ),
      );

      // Update the existing document in Firestore
      await db.collection("dues").doc(existingCustomer.id!).update({
        'received': existingCustomer.received!.map((d) => d.toJson()).toList(),
      });

      Get.snackbar('Success', 'Credit updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: primaryColor);
    } else {

      Get.snackbar('Error', 'Customer Not Found!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red);
    }

    // Clear the text editing controllers after adding/updating the entry
    customerId.clear();
    dues.clear();
    received.clear();
    address.clear();
  } catch (e) {
    print('Error adding/updating dues entry: $e');
    // Handle the error
  }
  update();
}

  int getTotalDues(List transactionsList) {
  int totalDues = 0;

  for (var transaction in transactionsList) {
    if (transaction is Dues && transaction.price != null) {
      totalDues += transaction.price!;
    }
  }

  return totalDues;
}


  Future<List> getTransactionsList(String documentId) async {
  var duesModel = duesList.firstWhere(
    (element) => element.id == documentId,
    orElse: () => DuesModel(),
  );

  var allTransactions = [...duesModel.dues ?? [], ...duesModel.received ?? []];
  allTransactions.sort((a, b) {
    if (a.date == null || b.date == null) {
      return 0;
    }
    return a.date!.compareTo(b.date!);
  });

  return allTransactions;
}


  Future<void> getDuesEntries() async {
    var duesEntries =
        await db.collection("dues").get();
    duesList.clear();
    for (var duesEntry in duesEntries.docs) {
      var duesModel = DuesModel.fromJson(duesEntry.data());
      duesList.add(duesModel);
    }
    update();
    // print("$duesList >>>>>>>. Dues Entries List");
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
   List<String?> getDuesNames() {
  return duesList.map((customer) => customer.customerName).toList();
}
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
