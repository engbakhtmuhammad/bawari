import 'dart:math';

import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:bawari/view/widgets/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../model/purchase_model.dart';
import '../../utils/constants.dart';
import '../widgets/custom_btn.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  DateTime selectedDate = DateTime.now();
  TextEditingController? billController;
  TextEditingController? dateController;
  TextEditingController nameController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController goodNoController = TextEditingController();
  TextEditingController cartonCountController = TextEditingController();
  TextEditingController perCartonCountController = TextEditingController();
  TextEditingController totalCountController = TextEditingController();
  TextEditingController priceController = TextEditingController();

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
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController!.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void addPurchase() async {
  try {
    // Parse values from controllers
    int parsedGoodsNo = int.parse(goodNoController.text.trim());
    int parsedCartonCount = int.parse(cartonCountController.text);
    int parsedPerCartonCount = int.parse(perCartonCountController.text);
    int parsedTotalCount = int.parse(totalCountController.text);
    int parsedPrice = int.parse(priceController.text);
    int parsedBillNo = int.parse(billController!.text);
    String name = nameController.text;
    String note = noteController.text;
    DateTime date = dateController as DateTime;

    // Add the purchase
    await purchaseService.addPurchase(
      goodsNo: parsedGoodsNo,
      cartonCount: parsedCartonCount,
      perCartonCount: parsedPerCartonCount,
      totalCount: parsedTotalCount,
      price: parsedPrice,
      billNo: parsedBillNo,
      name: name,
      note: note,
      date: date,
    );

    // Clear text controllers after adding purchase
    goodNoController.clear();
    cartonCountController.clear();
    perCartonCountController.clear();
    totalCountController.clear();
    priceController.clear();
    billController!.clear();
    nameController.clear();
    noteController.clear();

    // Fetch new data from Firebase
    List<PurchaseModel> allPurchases = await purchaseService.getAllPurchases();

    // Update the UI by triggering a rebuild
    setState(() {
      // Update any state variables if needed
      // For example, you might have a list of purchases that needs to be updated
      // purchases = allPurchases;
    });

    print('All Purchases: $allPurchases');
  } catch (e) {
    print("Error: Invalid number format $e");
  }
}


  @override
  void initState() {
    dateController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(selectedDate));
    billController = TextEditingController(text: billNumber.toString());
    super.initState();
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
                dateController: dateController,
                billController: billController),
            backContainerWidget(
              child: Column(
                children: [
                  textFieldWidget(
                      label: "نام",
                      imgPath: "assets/icons/name.png",
                      controller: nameController),
                  textFieldWidget(
                      label: "نوٹ",
                      imgPath: "assets/icons/note.png",
                      maxLine: 4),
                  textFieldWidget(
                      label: "سامان نمبر",
                      imgPath: "assets/icons/number.png",
                      inputType: TextInputType.number),
                  textFieldWidget(
                      label: "کارٹن تعداد",
                      imgPath: "assets/icons/cortons.png",
                      inputType: TextInputType.number),
                  textFieldWidget(
                      label: "فی کارٹن تعداد",
                      imgPath: "assets/icons/count.png",
                      inputType: TextInputType.number),
                  textFieldWidget(
                      label: "جمله تعداد",
                      imgPath: "assets/icons/total.png",
                      inputType: TextInputType.number),
                  textFieldWidget(
                      label: "قیمت",
                      imgPath: "assets/icons/price.png",
                      inputType: TextInputType.number),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: CustomButton(
                      onPressed: () {
                        addPurchase();
                        // setState(() async {
                        //   // billNumber+=billNumber;
                        // });
                      },
                    ),
                  )
                ],
              ),
            ),
            TableWidget(tableRows: tableRows, tableColumns: tableColumns),
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
