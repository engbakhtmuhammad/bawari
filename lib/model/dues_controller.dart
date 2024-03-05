import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'dues_model.dart';

class DuesController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  var duesList = RxList<DuesModel>();

  // Text editing controllers
  TextEditingController date = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController customerId = TextEditingController();
  String customerName = "گراک نوم";
  TextEditingController dues = TextEditingController();
  TextEditingController received = TextEditingController(text: "0");
  TextEditingController address = TextEditingController(text: '');

  @override
  void onInit() async {
    await getDuesEntries();
    super.onInit();
  }

Future<void> addDuesEntry() async {
  try {
    // Validate input before parsing
    int duesAmount = int.tryParse(dues.text) ?? 0;
    int receivedAmount = int.tryParse(received.text) ?? 0;

    var duesEntry = DuesModel(
      date:  DateFormat('yyyy-MM-dd').parse(date.text),
      customerId: customerId.text,
      customerName: customerName,
      dues: duesAmount,
      received: receivedAmount,
      address: address.text,
    );

    DocumentReference documentReference =
        await db.collection("dues").add(duesEntry.toJson());

    // Get the auto-generated ID
    String duesId = documentReference.id;

    // Update the dues model with the ID
    duesEntry.id = duesId;

    await db.collection("dues").doc(duesId).update({'id': duesId});

    getDuesEntries();

    // Clear the text editing controllers after adding the entry
    date.clear();
    customerId.clear();
    customerName="";
    dues.clear();
    received.clear();
    address.clear();

    // Any additional logic or feedback after adding the entry
    // ...

  } catch (e) {
    print('Error adding dues entry: $e');
    // Handle the error
  }
}


  Future<void> getDuesEntries() async {
    var duesEntries = await db.collection("dues").orderBy("date", descending: true).get();
    duesList.clear();
    for (var duesEntry in duesEntries.docs) {
      duesList.add(DuesModel.fromJson(duesEntry.data()));
    }
    update();
    print("$duesList >>>>>>>. Dues Entries List");
  }

  // Add other methods as needed, e.g., deleteDuesEntry, updateDuesEntry, etc.
}
