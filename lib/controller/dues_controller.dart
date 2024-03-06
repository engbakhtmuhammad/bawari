// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// import '../utils/colors.dart';
// import '../model/dues_model.dart';

// class DuesController extends GetxController {
//   FirebaseFirestore db = FirebaseFirestore.instance;
//   var duesList = RxList<DuesModel>();

//   // Text editing controllers
//   TextEditingController date = TextEditingController(
//       text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
//   TextEditingController customerId = TextEditingController();
//   String customerName = "گراک نوم";
//   TextEditingController dues = TextEditingController();
//   TextEditingController received = TextEditingController();
//   TextEditingController address = TextEditingController();

//   @override
//   void onInit() async {
//     await getDuesEntries();
//     super.onInit();
//   }

//   Future<void> addDuesEntry() async {
//     try {
//       // Validate input before parsing
//       int duesAmount = int.tryParse(dues.text) ?? 0;
//       int receivedAmount = int.tryParse(received.text) ?? 0;

//       var duesEntry = DuesModel(
//         date: DateFormat('yyyy-MM-dd').parse(date.text),
//         customerId: customerId.text,
//         customerName: customerName,
//         dues: duesAmount,
//         received: receivedAmount,
//         address: address.text,
//         subDuesList: []
//       );

//       DocumentReference documentReference =
//           await db.collection("dues").add(duesEntry.toJson());

//       // Get the auto-generated ID
//       String duesId = documentReference.id;

//       // Update the dues model with the ID
//       duesEntry.id = duesId;

//       await db.collection("dues").doc(duesId).update({'id': duesId});

//       getDuesEntries();
//       Get.snackbar('Success', 'Dues added successfully!',
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 3),
//           backgroundColor: primaryColor);

//       // Clear the text editing controllers after adding the entry
//       date.clear();
//       customerId.clear();
//       customerName = "";
//       dues.clear();
//       received.clear();
//       address.clear();
//     } catch (e) {
//       print('Error adding dues entry: $e');
//       // Handle the error
//     }
//     update();
//   }

//   Future<void> getDuesEntries() async {
//     var duesEntries =
//         await db.collection("dues").orderBy("date", descending: true).get();
//     duesList.clear();
//     for (var duesEntry in duesEntries.docs) {
//       duesList.add(DuesModel.fromJson(duesEntry.data()));
//     }
//     update();
//     print("$duesList >>>>>>>. Dues Entries List");
//   }

//   DuesModel? getCustomerByName(String name) {
//     for (var customer in duesList) {
//       if (customer.customerName == name) {
//         return customer;
//       }
//     }
//     return null; // Return null if no matching customer found
//   }
//    DuesModel? getDuesByName(String name) {
//     for (var dues in duesList) {
//       if (dues.customerName == name) {
//         return dues;
//       }
//     }
//     return null; // Return null if no matching customer found
//   }

//   void addToSubDueList(docId) {
//     try {
//       var duesEntry = DuesModel(
//         date: DateFormat('yyyy-MM-dd').parse(date.text),
//         customerName: customerName,
//         dues: int.parse(dues.text),
//         received: int.parse(received.text),
//         address: address.text,
//       );
//       var collection = FirebaseFirestore.instance.collection('dues');
// collection 
//     .doc(docId) // <-- Document ID
//     .set({'subDuesList': FieldValue.arrayUnion([duesEntry.toJson()])}) // <-- Add data
//     .then((_) {getDuesEntries();
//       Get.snackbar('Success', 'Dues added successfully!',
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 3),
//           backgroundColor: primaryColor);})
//     // ignore: invalid_return_type_for_catch_error
//     .catchError((error) => Get.snackbar('Failed', error,
//           snackPosition: SnackPosition.BOTTOM,
//           duration: const Duration(seconds: 3),
//           backgroundColor: primaryColor));
      

//       // Clear the text editing controllers after adding the entry
//       date.clear();
//       customerId.clear();
//       customerName = "";
//       dues.clear();
//       received.clear();
//       address.clear();
//     } catch (e) {
//       print('Error adding dues entry: $e');
//       // Handle the error
//     }
//     update();
//   }

//   void getDocumentId() async {
//   var duesEntries = await db.collection("dues").get();
//   for (var duesEntry in duesEntries.docs) {
//     String documentId = duesEntry.id;
//     print('Document ID: $documentId');
//   }
// }

// }
