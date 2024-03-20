import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BillNumberController extends GetxController {
  final CollectionReference _billNumberCollection =
      FirebaseFirestore.instance.collection('bill_number');

  RxInt _billNumber = 0.obs; // Define a reactive variable to hold the bill number

  int get billNumber => _billNumber.value; // Getter to access the bill number

  @override
  void onInit() {
    super.onInit();
    getBillNumber(); // Call method to get the current bill number when the controller initializes
  }

  Future<void> getBillNumber() async {
    try {
      var docSnapshot = await _billNumberCollection.doc('current').get();
      if (docSnapshot.exists) {
        _billNumber.value = docSnapshot['number'] ?? 0; // Update the bill number with the retrieved value
      } else {
        print('No bill number found.');
        _billNumber.value = 0; // Set bill number to 0 if no bill number found
      }
    } catch (e) {
      print('Error getting bill number: $e');
      // Handle the error as needed
      _billNumber.value = 0; // Set bill number to 0 in case of error
    }
    update();
    print(">>>>>>>>>>>>>>>>>> BillNumber: $billNumber and $_billNumber");
  }

  Future<void> saveBillNumber(int billNumber) async {
    try {
      await _billNumberCollection.doc('current').set({'number': billNumber});
      print('Bill number saved successfully.');
      _billNumber.value = billNumber; // Update the bill number locally after saving
    } catch (e) {
      print('Error saving bill number: $e');
      // Handle the error as needed
    }
    getBillNumber();update();
  }
}
