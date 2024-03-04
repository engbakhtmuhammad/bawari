import 'package:bawari/model/sale_model.dart';
import 'package:bawari/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

class SaleController extends GetxController {
  int autoBillNo = 1;
  TextEditingController bill = TextEditingController();
  TextEditingController date = TextEditingController(
      text: DateFormat('MM/dd/yyyy').format(DateTime.now()));
  TextEditingController name = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController goodsNo = TextEditingController();
  TextEditingController pieceCount = TextEditingController();
  TextEditingController cartonCount = TextEditingController();
  TextEditingController perCartonCount = TextEditingController();
  TextEditingController totalCount = TextEditingController();
  TextEditingController price = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;
  var saleList = RxList<SaleModel>();

  @override
  void onInit() {
    bill.text = autoBillNo.toString(); // Assign autoBillNo to bill controller
    getSale();
    super.onInit();
  }

  void addSale() async {
    var sale = SaleModel(
      name: name.text,
      note: note.text,
      goodsNo: int.tryParse(goodsNo.text) ?? 0,
      pieceCount: int.tryParse(pieceCount.text) ?? 0,
      cartonCount: int.tryParse(cartonCount.text) ?? 0,
      perCartonCount: int.tryParse(perCartonCount.text) ?? 0,
      totalCount: int.tryParse(totalCount.text) ?? 0,
      price: int.tryParse(price.text) ?? 0,
      billNo: int.tryParse(bill.text) ?? 0,
      date: DateFormat('MM/dd/yyyy').parse(date.text),
    );

    await db.collection("sales").add(sale.toJson()).whenComplete(() {
      print("Sale Added");
      getSale();

      // Show GetX Snackbar
      Get.snackbar('Success', 'Sale added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: primaryColor);

      // Clear all controllers except date and bill
      name.clear();
      note.clear();
      goodsNo.clear();
      pieceCount.clear();
      cartonCount.clear();
      perCartonCount.clear();
      totalCount.clear();
      price.clear();

      // Update bill controller value by adding 1
      autoBillNo++;
      bill.text = autoBillNo.toString();
    });
  }

  void getSale() async {
    var sales= await db.collection("sales").get();
    saleList.clear();
    for (var sale in sales.docs) {
      saleList.add(SaleModel.fromJson(sale.data()));

    }
    print("$saleList >>>>>>>. Sales List");
  }
}

