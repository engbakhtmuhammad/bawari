import 'package:bawari/controller/bill_controller.dart';
import 'package:bawari/model/credit_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';

class CreditController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  var creditList = RxList<CreditModel>();
  var filterCreditList = RxList<CreditModel>();
  BillNumberController billNumberController = Get.put(BillNumberController());
  int totalNetCredits = 0;

  TextEditingController date = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  TextEditingController customerId = TextEditingController();
  String customerName = "گراک نوم";
  TextEditingController address = TextEditingController();
  TextEditingController credits = TextEditingController();
  TextEditingController received = TextEditingController();

  @override
  void onInit() async {
    await getCreditEntries();
    filterCredits('');
    getTotalCreditsForAllCustomers();
    super.onInit();
  }

  Future<void> addCreditEntry() async {
    try {
      // Check if the customer name already exists
      var existingCustomer = creditList.firstWhere(
        (entry) => entry.customerName == customerName,
        orElse: () =>
            CreditModel(), // Provide a default value (empty CreditModel)
      );

      if (existingCustomer.id != null) {
        // If customer name exists, update the existing entry
        existingCustomer.credits!.add(
          Credit(
              price: int.parse(credits.text),
              date: _parseDate(date.text),
              address: address.text,
              billNo: billNumberController.billNumber),
        );
        existingCustomer.received!.add(
          Credit(
              price: int.parse("-${received.text}"),
              date: _parseDate(date.text),
              address: address.text,
              billNo: billNumberController.billNumber),
        );

        // Update the existing document in Firestore
        await db.collection("credits").doc(existingCustomer.id!).update({
          'received':
              existingCustomer.received!.map((d) => d.toJson()).toList(),
        });
        await db.collection("credits").doc(existingCustomer.id!).update({
          'credits': existingCustomer.credits!.map((d) => d.toJson()).toList(),
        });
        // autoBillNo + 10;
        billNumberController
            .saveBillNumber(billNumberController.billNumber + 10);
      } else {
        // If customer name doesn't exist, add a new entry
        var creditEntry = CreditModel(
          customerId: customerId.text,
          customerName: customerName,
          credits: [
            Credit(
                price: int.parse(credits.text),
                date: _parseDate(date.text),
                address: address.text,
                billNo: billNumberController.billNumber),
          ],
          received: [
            Credit(
                price: int.parse("-${received.text}"),
                date: _parseDate(date.text),
                address: address.text,
                billNo: billNumberController.billNumber),
          ],
        );

        DocumentReference documentReference =
            await db.collection("credits").add(creditEntry.toJson());

        // Get the auto-generated ID
        String creditId = documentReference.id;

        // Update the credits model with the ID
        creditEntry.id = creditId;

        await db.collection("credits").doc(creditId).update({'id': creditId});
        billNumberController
            .saveBillNumber(billNumberController.billNumber + 10);
      }

      // Clear the text editing controllers after adding/updating the entry
      credits.clear();
      received.clear();
      address.clear();
    } catch (e) {
      print('Error adding/updating credits entry: $e');
      // Handle the error
    }
    update();
  }

  DateTime _parseDate(String dateString) {
    // Try different date format patterns here until the correct one is found
    List<String> dateFormats = ['MM/dd/yyyy', 'yyyy-MM-dd', 'dd MMM yyyy'];

    for (String format in dateFormats) {
      try {
        return DateFormat(format).parse(dateString);
      } catch (e) {
        continue;
      }
    }

    // If no valid format is found, return the current date as a fallback
    return DateTime.now();
  }

  Future<void> addRecieveEntry() async {
    try {
      // Check if the customer name already exists
      var existingCustomer = creditList.firstWhere(
        (entry) => entry.customerName == customerName,
        orElse: () =>
            CreditModel(), // Provide a default value (empty CreditModel)
      );

      if (existingCustomer.id != null) {
        // If customer name exists, update the existing entry
        existingCustomer.received!.add(
          Credit(
              price: int.parse("-${received.text}"),
              date: _parseDate(date.text),
              address: address.text,
              billNo: billNumberController.billNumber),
        );

        // Update the existing document in Firestore
        await db.collection("credits").doc(existingCustomer.id!).update({
          'received':
              existingCustomer.received!.map((d) => d.toJson()).toList(),
        });

        Get.snackbar('Success', 'Credit updated successfully!',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            backgroundColor: primaryColor);
        // autoBillNo + 10;
        billNumberController
            .saveBillNumber(billNumberController.billNumber + 10);
      } else {
        Get.snackbar('Error', 'Customer Not Found!',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red);
      }

      // Clear the text editing controllers after adding/updating the entry
      credits.clear();
      received.clear();
      address.clear();
    } catch (e) {
      print('Error adding/updating credits entry: $e');
      // Handle the error
    }
    update();
  }

  double calculateCreditTotal(List<Credit> creditList) {
    double total = 0;

    for (var credits in creditList) {
      total += credits.price ?? 0;
    }

    return total;
  }

  int getTotalCreditsForAllCustomers() {
    int total = 0;
    for (var creditModel in creditList) {
      // Calculate the total credits for each customer
      int totalCredits = getTotalCredits(creditModel.credits ?? []);

      // Calculate the total received for each customer
      int totalReceived = getTotalCredits(creditModel.received ?? []);

      // Calculate the net credits for each customer
      int netCredits = totalCredits - totalReceived;

      // Add the net credits to the total net credits
      total += netCredits;
    }

    return total;
  }

  void updateTotalCredits() {
    totalNetCredits = getTotalCreditsForAllCustomers();
    update();
  }

  int getTotalCredits(List transactionsList) {
    int totalDues = 0;

    for (var transaction in transactionsList) {
      if (transaction is Credit && transaction.price != null) {
        totalDues += transaction.price!;
      }
    }

    return totalDues;
  }

  int getTotalReceived(List transactionsList) {
  int totalReceived = 0;

  for (var transaction in transactionsList) {
    if (transaction is Credit && transaction.price != null) {
      if (transaction.price! < 0) { // Assuming received amounts are stored as negative prices
        totalReceived += transaction.price!;
      }
    }
  }

  return totalReceived.abs(); // Return the absolute value to get the total received amount
}


  Future<List<Credit>> getTransactionsList(String customerId,
      {DateTime? date}) async {
    List<Credit> transactionsList = [];

    // Iterate through each credit entry in the credit list
    for (var creditModel in creditList) {
      // Check if the credit entry belongs to the specified customer
      if (creditModel.customerId == customerId) {
        // Add the credits and received amounts to the transactions list
        if (creditModel.credits != null) {
          transactionsList.addAll(creditModel.credits!);
        }
        if (creditModel.received != null) {
          transactionsList.addAll(creditModel.received!);
        }
      }
    }

    // If date is provided, filter transactions by date
    if (date != null) {
      transactionsList = transactionsList
          .where((transaction) =>
              transaction.date != null &&
              transaction.date!.year == date.year &&
              transaction.date!.month == date.month &&
              transaction.date!.day == date.day)
          .toList();
    }

    // Sort transactions by date in descending order
    transactionsList.sort((a, b) {
      if (a.date == null || b.date == null) {
        return 0;
      }
      return b.date!.compareTo(a.date!); // Compare in descending order
    });

    return transactionsList;
  }

  Future<void> getCreditEntries({DateTime? date}) async {
    var duesEntries = await db.collection("credits").get();
    creditList.clear();
    for (var creditEntry in duesEntries.docs) {
      var creditModel = CreditModel.fromJson(creditEntry.data());
      if (date == null) {
        // If date is null, add all credit entries
        creditList.add(creditModel);
      } else {
        // If date is not null, add credit entries that match the specified date
        if (creditModel.credits != null &&
                creditModel.credits!
                    .any((credit) => isCreditOnDate(credit, date)) ||
            creditModel.received != null &&
                creditModel.received!
                    .any((credit) => isCreditOnDate(credit, date))) {
          creditList.add(creditModel);
        }
      }
    }
    update();
  }

  bool isCreditOnDate(Credit credit, DateTime date) {
    return credit.date != null &&
        credit.date!.year == date.year &&
        credit.date!.month == date.month &&
        credit.date!.day == date.day;
  }

  CreditModel? getCreditByName(String name) {
    for (var credits in creditList) {
      if (credits.customerName == name) {
        return credits;
      }
    }
    return null; // Return null if no matching customer found
  }

  List<String?> getCreditNames() {
    return creditList.map((customer) => customer.customerName).toList();
  }

  double getTotalCreditsById(String customerId) {
    double total = 0;

    var creditModel = creditList.firstWhere(
      (element) => element.customerId == customerId,
      orElse: () => CreditModel(),
    );

    if (creditModel.credits != null) {
      total = calculateCreditTotal(creditModel.credits!);
    }

    return total;
  }

  double getTotalReceivedById(String customerId) {
    double total = 0;

    var creditModel = creditList.firstWhere(
      (element) => element.customerId == customerId,
      orElse: () => CreditModel(),
    );

    if (creditModel.received != null) {
      total = calculateCreditTotal(creditModel.received!);
    }

    return total;
  }

  int calculateDuesAmountById(String customerId) {
    return getTotalCreditsById(customerId).toInt() -
        getTotalReceivedById(customerId).toInt();
  }

  int calculateNetAmountById(String customerId) {
    var creditModel = creditList.firstWhere(
      (element) => element.customerId == customerId,
      orElse: () => CreditModel(),
    );

    print(">>>>>>>>>>>.. ${creditModel.customerName}");

    double totalCredit = 0;
    double totalReceived = 0;

    if (creditModel.credits != null) {
      totalCredit = calculateCreditTotal(creditModel.credits!);
    }

    if (creditModel.received != null) {
      totalReceived = calculateCreditTotal(creditModel.received!);
    }
    // print(">>>>>>>>>>>.. ${creditModel.received![0].price}");

    // Convert to int if you want to discard the decimal part
    int netAmount = (totalCredit - totalReceived).toInt();

    return netAmount;
  }

  double getTotalDuesByName(String name) {
    // Initialize the total dues variable
    double totalDues = 0;

    // Find the credit model for the customer by their name
    var creditModel = creditList.firstWhere(
      (element) => element.customerName == name,
      orElse: () => CreditModel(), // Return an empty CreditModel if not found
    );

    // Calculate the total dues if the credit model is found
    if (creditModel != null) {
      // Calculate the total credits
      double totalCredits = calculateCreditTotal(creditModel.credits ?? []);

      // Calculate the total received
      double totalReceived = calculateCreditTotal(creditModel.received ?? []);

      // Calculate the total dues
      totalDues = totalCredits - totalReceived;
    }

    // Return the total dues
    return totalDues;
  }

  void filterCredits(String query) {
    if (query.isEmpty) {
      // If the search query is empty, show all credits
      filterCreditList.assignAll(creditList);
    } else {
      // If the search query is not empty, filter credits by name
      filterCreditList.assignAll(
        creditList.where(
          (credit) =>
              credit.customerName!.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }
}
