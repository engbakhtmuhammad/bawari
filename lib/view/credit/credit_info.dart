import 'package:bawari/controller/dues_controller.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:bawari/view/credit/show_credit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/credit_controller.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class CreditInfoScreen extends StatefulWidget {
  const CreditInfoScreen({super.key});

  @override
  State<CreditInfoScreen> createState() => _CreditInfoScreenState();
}

class _CreditInfoScreenState extends State<CreditInfoScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CreditController creditController = Get.put(CreditController());
  DuesController customerController = Get.put(DuesController());
  // Example data, you can replace it with your dynamic data
  List<String> tableColumns = [
    "نمبر",
    "گاهک",
    "پیسے",
    "تاریخ",
    "حوالا ادرس",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBarWidget(
        title: "وصولی کهاته",
        openDrawer: () => scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: drawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              creditController.getCreditEntries();
              return SizedBox(
                  height: creditController.creditList.length * 50 + 60,
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
                              row < creditController.creditList.length;
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
                                DataCell(
                                  Text(
                                    creditController
                                        .creditList[row].credits![0].address
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    DateFormat('yyyy-MM-dd').format(
                                        creditController
                                            .creditList[row].credits![0].date!),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    creditController
                                        .calculateCreditTotal(creditController
                                            .creditList[row].credits!)
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    creditController
                                        .creditList[row].customerName
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                  onTap: () async {
                                    var creditModel = await creditController
                                        .getCreditByName(creditController
                                            .creditList[row].customerName
                                            .toString());
                                            var transaction = await creditController.getTransactionsList(creditModel!.id.toString());
                                    Get.to(ShowCreditScreen(
                                        transactionsList: transaction));
                                  },
                                ),
                                DataCell(
                                  Text(
                                    "${row + 1}",
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
                    "Total: ${creditController.getTotalCreditsForAllCustomers()}",
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
