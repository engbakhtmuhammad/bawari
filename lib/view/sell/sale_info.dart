import 'package:bawari/controller/sale_controller.dart';
import 'package:bawari/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:get/get.dart';
import 'package:bawari/utils/colors.dart';
import '../../utils/constants.dart';

class SaleInfoScreen extends StatefulWidget {
  const SaleInfoScreen({super.key});

  @override
  State<SaleInfoScreen> createState() => _SaleInfoScreenState();
}

class _SaleInfoScreenState extends State<SaleInfoScreen> {
  SaleController saleController = Get.put(SaleController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String customerId = '';

// Example data, you can replace it with your dynamic data
  List<String> tableColumns = [
    "سامان",
    "پیس تعداد",
    "کارتن تعداد",
    "في كارتن تعداد",
    "جمله تعداد",
    "في تعدادقيمت",
    "مکمل تعدادقيمت",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBarWidget(
        title: "سامان فروخت",
        openDrawer: () => scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: drawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            billAndDateWidget(
              title: "ابتدائی",
              imgPath: "assets/icons/calendar.png",
              title2: "اختتامي",
              imgPath2: "assets/icons/calendar.png",
              dateController: saleController.endDate,
              onPressed2: () => selectDate(saleController.endDate),
              billController: saleController.startDate,
              onPressed: () => selectDate(saleController.startDate),
            ),
            SizedBox(
              height: defaultPadding,
            ),
            Obx(() {
              saleController.getSale();
              return SizedBox(
                  height: saleController.saleList.length * 50 + 60,
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
                              row < saleController.saleList.length;
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
                                    "${int.parse(saleController.saleList[row].price
                                        .toString())*int.parse(saleController.saleList[row].totalCount
                                        .toString())}",
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    saleController.saleList[row].price
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    saleController.saleList[row].totalCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    saleController.saleList[row].perCartonCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    saleController.saleList[row].cartonCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    saleController.saleList[row].pieceCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    saleController.saleList[row].name
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
                                      onTap: (){
                                        // Add print option
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
