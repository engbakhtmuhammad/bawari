import 'package:bawari/controller/bill_controller.dart';
import 'package:bawari/model/sale_model.dart';
import 'package:bawari/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class SaleController extends GetxController {
  TextEditingController bill = TextEditingController();
  BillNumberController billNumberController= Get.put(BillNumberController());
  TextEditingController startDate = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController endDate = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime(2024, 3, 3)));
  TextEditingController date = TextEditingController(
      text: DateFormat('MM/dd/yyyy').format(DateTime.now()));
  String name = "سامان نوم";
  String customerId="";
  String customerName = "";
  TextEditingController note = TextEditingController();
  TextEditingController goodsNo = TextEditingController();
  TextEditingController pieceCount = TextEditingController();
  TextEditingController cartonCount = TextEditingController();
  TextEditingController perCartonCount = TextEditingController();
  TextEditingController totalCount = TextEditingController();
  TextEditingController totalPrice = TextEditingController();
  TextEditingController receivedPrice= TextEditingController();
  TextEditingController price = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;
  var saleList = RxList<SaleModel>();
  var filteredSaleList = <SaleModel>[].obs;

  @override
  void onInit() {
    billNumberController.getBillNumber();
    bill.text = billNumberController.billNumber.toString(); // Assign autoBillNo to bill controller
    getSale();
    filterSales('');
    super.onInit();
  }

  void addSale() async {
    try {
      var sale = SaleModel(
        name: name,
        customerId: customerId,
        customerName: customerName,
        note: note.text,
        goodsNo: int.tryParse(goodsNo.text) ?? 0,
        pieceCount: int.tryParse(pieceCount.text) ?? 0,
        cartonCount: int.tryParse(cartonCount.text) ?? 0,
        perCartonCount: int.tryParse(perCartonCount.text) ?? 0,
        totalCount: int.tryParse(totalCount.text) ?? 0,
        totalPrice: int.tryParse(totalPrice.text) ?? 0,
        price: int.tryParse(price.text) ?? 0,
        billNo: int.tryParse(bill.text) ?? 0,
        date: DateFormat('MM/dd/yyyy').parse(date.text),
        recievedCash: int.tryParse(receivedPrice.text) ?? 0,
      );
      var documentReference = await db.collection("sales").add(sale.toJson());
      var saleId = documentReference.id;
      print(">>>>>>>>>>>>>>>>>>>>>>> Reference: $documentReference");

      await db
          .collection("sales")
          .doc(saleId)
          .update({'id': saleId}).then((value) async {
        getSale();

        // Show GetX Snackbar
        Get.snackbar('Success', 'Sale added successfully!',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            backgroundColor: primaryColor);

        // Clear all controllers except date and bill
        note.clear();
        goodsNo.clear();
        pieceCount.clear();
        cartonCount.clear();
        perCartonCount.clear();
        totalCount.clear();
        totalPrice.clear();
        price.clear();
        receivedPrice.clear();

        // Update bill controller value by adding 1
        // autoBillNo+10;
        billNumberController.saveBillNumber(billNumberController.billNumber+10);
        bill.text = billNumberController.billNumber.toString();
      });
    } catch (e) {
      print('Error adding sale: $e');
      // Handle the error
      Get.snackbar('Error', 'Failed to add sale. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red);
    }
  }

  void getSale() async {
    var sales = await db.collection("sales").get();
    saleList.clear();
    for (var sale in sales.docs) {
      saleList.add(SaleModel.fromJson(sale.data()));
    }
  }

  double getTotalPrice() {
    double totalPrice = 0;

    for (var sale in saleList) {
      totalPrice += sale.price ?? 0;
    }

    return totalPrice;
  }

  int getTotalCartonCount() {
    int totalCartonCount = 0;

    for (var sale in saleList) {
      totalCartonCount += sale.cartonCount ?? 0;
    }

    return totalCartonCount;
  }

  int getTotalPieceCount() {
    int totalPieceCount = 0;

    for (var sale in saleList) {
      totalPieceCount += sale.pieceCount ?? 0;
    }

    return totalPieceCount;
  }

   void filterSales(String query, {DateTime? date}) {
  if (query.isEmpty && date == null) {
    // If both query and date are null, show all purchases
    filteredSaleList.assignAll(saleList);
  } else if (query.isEmpty) {
    // If only query is null, filter purchases by date
    filteredSaleList.assignAll(
      saleList.where(
        (sale) =>
            sale.date != null &&
            sale.date!.year == date!.year &&
            sale.date!.month == date.month &&
            sale.date!.day == date.day,
      ),
    );
  } else if (date == null) {
    // If only date is null, filter purchases by name
    filteredSaleList.assignAll(
      saleList.where(
        (sale) => sale.name!.toLowerCase().contains(query.toLowerCase()),
      ),
    );
  } else {
    // If both query and date are not null, filter purchases by name and date
    filteredSaleList.assignAll(
      saleList.where(
        (sale) =>
            sale.name!.toLowerCase().contains(query.toLowerCase()) &&
            sale.date != null &&
            sale.date!.year == date.year &&
            sale.date!.month == date.month &&
            sale.date!.day == date.day,
      ),
    );
  }
}

}
