import 'package:bawari/controller/purchase_controller.dart';
import 'package:bawari/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/text_styles.dart';
import '../invoice/file_handle_api.dart';
import '../invoice/purchase_invoice.dart';

class PurchaseInfoScreen extends StatefulWidget {
  const PurchaseInfoScreen({super.key});

  @override
  State<PurchaseInfoScreen> createState() => _PurchaseInfoScreenState();
}

class _PurchaseInfoScreenState extends State<PurchaseInfoScreen> {
  PurchaseController purchaseController = Get.put(PurchaseController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //  String? selectedValue;
  // Example data, you can replace it with your dynamic data
  List<String> tableColumns = [
    "سامان",
    "کارتن تعداد",
    "في كارتن تعداد",
    "مکمل تعداد",
    "في تعدادقيمت",
    "مکمل تعدادقيمت",
    "تاریخ",
  ];

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBarWidget(title: "خریداری معلومات",openDrawer: () => scaffoldKey.currentState?.openDrawer(),),
      drawer: drawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            billAndDateWidget(
                title: "ابتدائی",
                imgPath: "assets/icons/calendar.png",
                title2: "اختتامي",
                imgPath2: "assets/icons/calendar.png",
                dateController: purchaseController.endDate,onPressed2: () => selectDate(purchaseController.endDate),
                billController: purchaseController.startDate,onPressed: () => selectDate(purchaseController.startDate),),
            SizedBox(
              height: defaultPadding,
            ),
            
            Obx(() {
              purchaseController.filterPurchases();
              return SizedBox(
                  height: purchaseController.filteredPurchases.length * 50 + 60,
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
                            const DataColumn(
                            label: SizedBox
                                .shrink(), // Empty space for the trash icon
                          ),
                        ],
                        rows: [
                          for (var row = 0;
                              row < purchaseController.filteredPurchases.length;
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
                                   "${ DateFormat('yyyy-MM-dd').format(purchaseController.filteredPurchases[row].date!
                                        )}",
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //7
                                DataCell(
                                  Text(
                                    "${int.parse(purchaseController.filteredPurchases[row].price.toString())*int.parse(purchaseController.filteredPurchases[row].totalCount.toString())}",
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //6
                                DataCell(
                                  Text(
                                    purchaseController.filteredPurchases[row].price
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //5
                                DataCell(
                                  Text(
                                    purchaseController
                                        .filteredPurchases[row].totalCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //4
                                DataCell(
                                  Text(
                                    purchaseController
                                        .filteredPurchases[row].perCartonCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //3
                                DataCell(
                                  Text(
                                    purchaseController.filteredPurchases[row].cartonCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    purchaseController.filteredPurchases[row].name
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: GestureDetector(
                                      child: Padding(
                                        padding:  EdgeInsets.only(left: defaultPadding),
                                        child: Image.asset("assets/icons/print.png"),
                                      ),
                                      onTap: () async {
                                            final pdfFile = await PurchaseInvoicePdf.generate(purchase: purchaseController.filteredPurchases[row]);
                                            // opening the pdf file
                                            FileHandleApi.openFile(pdfFile);
                                            // Get.to(InvoiceScreen());
                                          }
                                    )
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
                        controller: purchaseController.searchController,
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
