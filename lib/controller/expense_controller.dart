import 'package:bawari/controller/bill_controller.dart';
import 'package:bawari/utils/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/expense_model.dart';
import '../utils/colors.dart';

class ExpenseController extends GetxController {
  TextEditingController price = TextEditingController();
  BillNumberController billNumberController = Get.put(BillNumberController());
  late TextEditingController billNo;
  String expenseType = "خرچه";
  TextEditingController note = TextEditingController();
  TextEditingController startDate = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime(2024,01,01)));
  TextEditingController endDate = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  FirebaseFirestore db = FirebaseFirestore.instance;
  var expenseList = RxList<ExpenseModel>();
  var filterExpenseList = RxList<ExpenseModel>();
  int autoExpenseId = 1;

  @override
  void onInit() async {
    await getExpenses();
    // Assign autoBillNo to the billNo controller
    billNo =
        TextEditingController(text: billNumberController.billNumber.toString());
    filterExpense('');
    super.onInit();
  }

  void addExpense() async {
    try {
      var expense = ExpenseModel(
        billNo: billNumberController.billNumber, // Use the autoBillNo directly
        price: int.parse(price.text),
        expenseType: expenseType,
        note: note.text,
        date: DateFormat('yyyy-MM-dd').parse(startDate.text),
      );

      DocumentReference documentReference =
          await db.collection("expenses").add(expense.toJson());

      // Get the auto-generated ID
      String expenseId = documentReference.id;

      // Update the expense model with the ID
      expense.id = expenseId;

      await db.collection("expenses").doc(expenseId).update({'id': expenseId});

      getExpenses();

      Get.snackbar('Success', 'Expense added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: primaryColor);
      billNumberController.saveBillNumber(billNumberController.billNumber + 10);

      price.clear();
      expenseType = "خرچه";
      note.clear();
      startDate.clear();
      startDate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    } catch (e) {
      print('Error adding expense: $e');

      Get.snackbar('Error', 'Failed to add expense. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red);
    }
  }

  Future<void> getExpenses() async {
    var expenses = await db
        .collection("expenses")
        .orderBy("date", descending: true) // Order by date in descending order
        .get();

    expenseList.clear();
    for (var expense in expenses.docs) {
      expenseList.add(ExpenseModel.fromJson(expense.data()));
    }
    update();
    print("$expenseList >>>>>>>. Expenses List");
  }

  void deleteExpense(String expenseId) async {
    try {
      await db.collection("expenses").doc(expenseId).delete();
      print("Expense Deleted");

      Get.snackbar('Success', 'Expense deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: primaryColor);
    } catch (e) {
      print('Error deleting expense: $e');

      Get.snackbar('Error', 'Failed to delete expense. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red);
    }
    getExpenses();
    update();
  }

  List<ExpenseModel> getPurchasesByExpenseType(String type) {
    return expenseList.where((expense) => expense.expenseType == type).toList();
  }

  void filterExpense(String query) {
    print(">>>>>>>>>>>>>>>>>> $filterExpenseList");
    if (query.isEmpty) {
      // If the search query is empty, show all purchases
      filterExpenseList.assignAll(expenseList);
    } else {
      // If the search query is not empty, filter purchases by name
      filterExpenseList.assignAll(
        expenseList.where(
          (expense) =>
              expense.expenseType!.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
    filterExpenseByDateRange();
  }

  void filterExpenseByDateRange() {
    if (startDate == null || endDate == null) return;
    DateTime start = DateFormat('yyyy-MM-dd').parse(startDate.text);
    DateTime end = DateFormat('yyyy-MM-dd').parse(endDate.text);
    filterExpenseList.assignAll(
      expenseList.where(
        (expense) =>
            expense.date!.isAfter(start) && expense.date!.isBefore(end),
      ),
    );
    print(">>>>>>>>>>>>>>>>>> $filterExpenseList");
  }
  
}
