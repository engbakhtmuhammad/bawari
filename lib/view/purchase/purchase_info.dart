import 'package:bawari/controller/purchase_controller.dart';
import 'package:bawari/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/text_styles.dart';

class PurchaseInfoScreen extends StatefulWidget {
  const PurchaseInfoScreen({super.key});

  @override
  State<PurchaseInfoScreen> createState() => _PurchaseInfoScreenState();
}

class _PurchaseInfoScreenState extends State<PurchaseInfoScreen> {
  PurchaseController purchaseController = Get.put(PurchaseController());
  //  String? selectedValue;
  // Example data, you can replace it with your dynamic data
  List<String> tableColumns = [
    "سامان",
    "پیس تعداد",
    "کارتن تعداد",
    "في كارتن تعداد",
    "مکمل تعداد",
    "في تعدادقيمت",
    "مکمل تعداد",
    "في تعدادقيمت",
  ];
  List<List<String>> tableRows = [
    ["1", "محمد صادق لشکرگاه", "12453"],
    ["2", "با خان لشکرقا", "12453"],
    ["3", "عبد الغفار كرئش", "12453"],
    ["4", "حاجی محمد جان", "12453"],
    ["5", "جیلانی لشکرگاه", "12453"],
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
      appBar: appBarWidget(title: "خریداری معلومات", context: context),
      drawer: drawerWidget(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            billAndDateWidget(
                title: "ابتدائی",
                imgPath: "assets/icons/calendar.png",
                title2: "اختتامي",
                imgPath2: "assets/icons/calendar.png",
                dateController: purchaseController.endDate,onPressed2: () => _selectDate(context),
                billController: purchaseController.startDate,onPressed: () => _selectDate(context),),
            // TableWidget(tableRows: tableRows, tableColumns: tableColumns),
            SizedBox(
              height: defaultPadding,
            ),
            
            Obx(() {
              purchaseController.getPurchasesBetweenDates();
              return SizedBox(
                  height: purchaseController.purchaseList.length * 50 + 60,
                  width: double.infinity,
                  child: ListView(
                    shrinkWrap: true,
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(5.0),
                    children: <Widget>[
                      DataTable(
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => greyColor),
                        columnSpacing: 10.0,
                        columns: [
                          for (var i = tableColumns.length; i > 0; i--)
                            DataColumn(
                              numeric: true,
                              label: Text(
                                "${tableColumns[i - 1]}   ",
                                textAlign: TextAlign.center,
                                style: boldTextStyle(color: whiteColor),
                              ),
                            ),
                        ],
                        rows: [
                          for (var row = 0;
                              row < purchaseController.purchaseList.length;
                              row++)
                            DataRow(
                              color: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.08);
                                  }
                                  return Colors.transparent;
                                },
                              ),
                              cells: [
                                //8
                                DataCell(
                                  Text(
                                    purchaseController.purchaseList[row].date
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //7
                                DataCell(
                                  Text(
                                    purchaseController
                                        .purchaseList[row].totalCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //6
                                DataCell(
                                  Text(
                                    purchaseController.purchaseList[row].price
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //5
                                DataCell(
                                  Text(
                                    purchaseController
                                        .purchaseList[row].perCartonCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //4
                                DataCell(
                                  Text(
                                    purchaseController
                                        .purchaseList[row].cartonCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //3
                                DataCell(
                                  Text(
                                    purchaseController.purchaseList[row].note
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),

                                //2
                                DataCell(
                                  Text(
                                    purchaseController.purchaseList[row].billNo
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //1
                                DataCell(
                                  Text(
                                    purchaseController.purchaseList[row].name
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ));
            }),
            Container(
              height: 50,
              width: double.infinity,
              color: primaryColor,
              child: Center(
                child: ListTile(
                  trailing: Text(
                    "توثل ",
                    style: boldTextStyle(color: whiteColor),
                  ),
                  leading: Obx(
                    ()=> Text(
                      purchaseController.getTotalPrice().toString(),
                      style: primaryTextStyle(color: whiteColor),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              width: double.infinity,
              height: 50,
              color: secondaryColor,
              child: Row(
                children: [
                  Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(defaultRadius),
                      ),
                      child: textFieldWidget(
                          label: "search", imgPath: "", isSearch: true)),
                  Spacer(),
                  Text(
                    "1-3 of 6 Columns",
                    style: primaryTextStyle(color: whiteColor, size: 12),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
