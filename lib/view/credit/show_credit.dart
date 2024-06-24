import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/credit_controller.dart';
import '../../utils/constants.dart';

// ignore: must_be_immutable
class ShowCreditScreen extends StatefulWidget {
  var transactionsList;
   ShowCreditScreen({super.key, this.transactionsList});

  @override
  State<ShowCreditScreen> createState() => _ShowCreditScreenState();
}

class _ShowCreditScreenState extends State<ShowCreditScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CreditController creditController = Get.put(CreditController());
  List<String> tableColumns = [
    "ور باندی نوم",
    "پیسے",
    "تاریخ",
    "حوالا ادرس",
  ];

  @override
  void initState() {
    super.initState();
  }

  
  List<DataRow> buildDataRows()  {
    List<DataRow> rows = [];
      for (var subRow = 0; subRow < widget.transactionsList.length; subRow++) {
        DataRow dataRow = DataRow(
          color: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.08);
              }
              return Colors.transparent;
            },
          ),
          cells: [
            DataCell(
              Text(
                widget.transactionsList[subRow].address.toString(),
                textAlign: TextAlign.center,
                style: primaryTextStyle(size: 14),
              ),
            ),
            DataCell(
              Text(
                DateFormat('yyyy-MM-dd').format(widget.transactionsList[subRow].date),
                textAlign: TextAlign.center,
                style: primaryTextStyle(size: 14),
              ),
            ),
            DataCell(
              Text(
                widget.transactionsList[subRow].price.toString(),
                textAlign: TextAlign.center,
                style: primaryTextStyle(size: 14,color: widget.transactionsList[subRow].price < 0 ? Colors.red :blackColor),
              ),
            ),
            DataCell(
              Text(
                creditController.customerName.toString(),
                textAlign: TextAlign.center,
                style: primaryTextStyle(size: 14),
              ),
            ),
          ],
        );
        rows.add(dataRow);
      }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBarWidget(
        title: "ورباندی کهاته",
        openDrawer: () => scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: drawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Obx(() {
              // creditController.getDuesEntries();
               SizedBox(
                  height:(widget.transactionsList.length * 50 + 60).toDouble(),

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
                        rows: buildDataRows()
                      ),
                    ],
                  )),
            // }),
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
                    "توثل بقايا  ${creditController.getTotalCredits(widget.transactionsList)}",
                    style: boldTextStyle(color: whiteColor,),
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
