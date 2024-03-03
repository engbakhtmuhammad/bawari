import 'dart:math';

import 'package:bawari/controller/purchase_controller.dart';
import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:bawari/view/widgets/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';

import '../../utils/constants.dart';
import '../widgets/custom_btn.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  PurchaseController purchaseController = Get.put(PurchaseController());

// Example data, you can replace it with your dynamic data
  List<String> tableColumns = [
    "سامان",
    "پیس تعداد",
    "کارتن تعداد",
    "في كارتن تعداد",
    "مکمل تعداد",
    "في تعدادقيمت",
  ];
  List<List<String>> tableRows = [
    ["باوری لمیت (1 لیتر)", "5", "5", "12", "112", "12453"],
    ["باوری لمیت (1 لیتر)", "5", "5", "12", "112", "12453"],
  ];
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != purchaseController.date) {
      setState(() {
        purchaseController.date.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title: "سامان خرید", context: context),
      drawer: drawerWidget(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            billAndDateWidget(
                onPressed2: () => _selectDate(context),
                dateController: purchaseController.date,
                billController: purchaseController.bill),
            backContainerWidget(
              child: Column(
                children: [
                  textFieldWidget(
                      label: "نام",
                      imgPath: "assets/icons/name.png",
                      controller: purchaseController.name),
                  textFieldWidget(
                      label: "نوٹ",
                      imgPath: "assets/icons/note.png",
                      maxLine: 4,
                      controller: purchaseController.note),
                  textFieldWidget(
                      label: "سامان نمبر",
                      imgPath: "assets/icons/number.png",
                      inputType: TextInputType.number,
                      controller: purchaseController.goodsNo),
                  textFieldWidget(
                      label: "کارٹن تعداد",
                      imgPath: "assets/icons/cortons.png",
                      inputType: TextInputType.number,
                      controller: purchaseController.cartonCount),
                  textFieldWidget(
                      label: "فی کارٹن تعداد",
                      imgPath: "assets/icons/count.png",
                      inputType: TextInputType.number,
                      controller: purchaseController.perCartonCount),
                  textFieldWidget(
                      label: "جمله تعداد",
                      imgPath: "assets/icons/total.png",
                      inputType: TextInputType.number,
                      controller: purchaseController.totalCount),
                  textFieldWidget(
                      label: "قیمت",
                      imgPath: "assets/icons/price.png",
                      inputType: TextInputType.number,
                      controller: purchaseController.price),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: CustomButton(
                      onPressed: () {
                        purchaseController.addPurchase();
                      },
                    ),
                  )
                ],
              ),
            ),
            // TableWidget(tableRows: purchaseController.purchaseList, tableColumns: tableColumns),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 70,
              padding:
                  EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              width: double.infinity,
              color: secondaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "ٹوٹل بل",
                    style: primaryTextStyle(color: whiteColor),
                  ),
                  Text(
                    "کارٹن تعداد",
                    style: primaryTextStyle(color: whiteColor),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
