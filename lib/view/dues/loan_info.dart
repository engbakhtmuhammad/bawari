import 'package:bawari/controller/customer_controller.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/dues_controller.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class LoanInfoScreen extends StatefulWidget {
  const LoanInfoScreen({super.key});

  @override
  State<LoanInfoScreen> createState() => _LoanInfoScreenState();
}

class _LoanInfoScreenState extends State<LoanInfoScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DuesController duesController = Get.put(DuesController());
  CustomerController customerController = Get.put(CustomerController());
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
        title: "پور معلومات",openDrawer: () => scaffoldKey.currentState?.openDrawer(),
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
              billController: duesController.startDate,
              dateController: duesController.endDate,
              onPressed: () => selectDate(duesController.startDate),
              onPressed2: () => selectDate(duesController.endDate),
            ),
            Obx(() {
              duesController.getDuesEntries();
              return SizedBox(
                  height: duesController.duesList.length * 50 + 60,
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
                              )
                          ],
                          rows:

                           [
                            for (var row = 0;
                                row < duesController.duesList.length;
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
                                     duesController.duesList[row].dues![0].address
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: primaryTextStyle(size: 14),
                                    ),
                                  ),
                                   DataCell(
                                    Text(
                                      DateFormat('yyyy-MM-dd').format(duesController.duesList[row].dues![0].date!),
                                      textAlign: TextAlign.center,
                                      style: primaryTextStyle(size: 14),
                                    ),
                                  ),
                                  
                                  DataCell(
                                    Text(
                                      duesController.calculateDuesTotal(duesController.duesList[row].dues!).toString(),
                                      textAlign: TextAlign.center,
                                      style: primaryTextStyle(size: 14),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      duesController.duesList[row].customerName
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: primaryTextStyle(size: 14),
                                    ),
                                  ),
                                   DataCell(
                                    Text(
                                      duesController.duesList[row].dues![0].billNo
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
                    "Total: ${duesController.getTotalDuesForAllCustomers()}",
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
