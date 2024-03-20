import 'package:bawari/controller/bill_controller.dart';
import 'package:bawari/utils/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/dues_model.dart';
import '../utils/colors.dart';

class DuesController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  BillNumberController billNumberController = Get.put(BillNumberController());
  var duesList = RxList<DuesModel>();

  TextEditingController date = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    
  );
  TextEditingController startDate = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    
  );TextEditingController endDate = TextEditingController(
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
            billNo: billNumberController.billNumber
            
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
            // autoBillNo+10;
            billNumberController.saveBillNumber(billNumberController.billNumber+10);
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
              billNo: billNumberController.billNumber
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
            // autoBillNo+10;
            billNumberController.saveBillNumber(billNumberController.billNumber+10);
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
            billNo: billNumberController.billNumber
          ),
        );

        // Update the existing document in Firestore
        await db.collection("dues").doc(existingCustomer.id!).update({
          'received':
              existingCustomer.received!.map((d) => d.toJson()).toList(),
        });

        Get.snackbar('Success', 'Credit updated successfully!',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            backgroundColor: primaryColor);
            // autoBillNo+10;
            billNumberController.saveBillNumber(billNumberController.billNumber+10);
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

  double calculateDuesTotal(List<Dues> duesList) {
    double total = 0;

    for (var dues in duesList) {
      total += dues.price ?? 0;
    }

    return total;
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

    var allTransactions = [
      ...duesModel.dues ?? [],
      ...duesModel.received ?? []
    ];
    allTransactions.sort((a, b) {
      if (a.date == null || b.date == null) {
        return 0;
      }
      return a.date!.compareTo(b.date!);
    });

    return allTransactions;
  }

  Future<void> getDuesEntries() async {
    var duesEntries = await db.collection("dues").get();
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

  int getTotalDuesForCustomer(String customerName) {
    var duesModel = getDuesByName(customerName);

    if (duesModel != null) {
      var allTransactions = [...duesModel.dues ?? [], ...duesModel.received ?? []];
      return getTotalDues(allTransactions);
    }

    return 0;
  }

  int getTotalReceivedForCustomer(String customerName) {
    var duesModel = getDuesByName(customerName);

    if (duesModel != null) {
      var allTransactions = duesModel.received ?? [];
      return getTotalDues(allTransactions);
    }

    return 0;
  }

  int getTotalDuesForAllCustomers() {
    int totalDues = 0;

    for (var duesModel in duesList) {
      var allTransactions = [...duesModel.dues ?? [], ...duesModel.received ?? []];
      totalDues += getTotalDues(allTransactions);
    }

    return totalDues;
  }

  int getTotalReceivedForAllCustomers() {
    int totalReceived = 0;

    for (var duesModel in duesList) {
      var allTransactions = duesModel.received ?? [];
      totalReceived += getTotalDues(allTransactions);
    }

    return totalReceived;
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

