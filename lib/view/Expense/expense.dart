import 'package:bawari/controller/expense_controller.dart';
import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/constants.dart';
import 'package:bawari/view/widgets/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/text_styles.dart';

class ExpenseInfoScreen extends StatefulWidget {
  const ExpenseInfoScreen({super.key});

  @override
  State<ExpenseInfoScreen> createState() => _ExpenseInfoScreenState();
}

class _ExpenseInfoScreenState extends State<ExpenseInfoScreen> {
  ExpenseController expenseController = Get.put(ExpenseController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // Example data, you can replace it with your dynamic data
  List<String> tableColumns = [
    "تمبر",
    "خرچه نوم",
    "پیسے",
    "تفصيل",
    "تاریخ",
  ];
  List<List<String>> tableRows = [
    ["1", "محمد صادق لشکرگاه", "12453"],
    ["2", "با خان لشکرقا", "12453"],
    ["3", "عبد الغفار كرئش", "12453"],
    ["4", "حاجی محمد جان", "12453"],
    ["5", "جیلانی لشکرگاه", "12453"],
  ];

  var dropDownList = const [
    DropdownMenuItem(
      alignment: Alignment.centerLeft,
      value: "دفتر کا خرچه",
      child: Text("دفتر کا خرچه"),
    ),
    DropdownMenuItem(
      alignment: Alignment.centerLeft,
      value: "گھر کا خرچه",
      child: Text("گھر کا خرچه"),
    ),
    DropdownMenuItem(
      alignment: Alignment.centerLeft,
      value: "اپنا خرچه",
      child: Text("اپنا خرچه"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBarWidget(title: "ده خرچے معلومات",openDrawer: () => scaffoldKey.currentState?.openDrawer(),),
      drawer: drawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            billAndDateWidget(
              title: "ابتدائی",
              imgPath: "assets/icons/calendar.png",
              title2: "اختتامي",
              imgPath2: "assets/icons/calendar.png",
              billController: expenseController.startDate,
              dateController: expenseController.endDate,
              onPressed: () => selectDate(expenseController.startDate),
              onPressed2: () => selectDate(expenseController.endDate),
            ),
            Obx(() {
              expenseController.getExpenses();
              return SizedBox(
                  height: expenseController.expenseList.length * 50 + 60,
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
                              row < expenseController.expenseList.length;
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
                                    DateFormat('yyyy-MM-dd').format(
                                        expenseController
                                                .expenseList[row].date ??
                                            DateTime.now()),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //7
                                DataCell(
                                  Text(
                                    expenseController.expenseList[row].note
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //6
                                DataCell(
                                  Text(
                                    expenseController.expenseList[row].price
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //5
                                DataCell(
                                  Text(
                                    expenseController
                                        .expenseList[row].expenseType
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //4
                                DataCell(
                                  Text(
                                    expenseController.expenseList[row].billNo
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                // Trash icon cell
                                DataCell(
                                  Center(
                                      child: GestureDetector(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: defaultPadding),
                                      child: Image.asset(
                                          "assets/icons/print.png"),
                                    ),
                                    onTap: () {},
                                  )),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddExpenseDialog();
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void showAddExpenseDialog() {
    Get.defaultDialog(
      title: 'خرچه',
      content: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              textFieldWidget(
                  label: "تمبر",
                  imgPath: "assets/icons/invoice.png",
                  controller: expenseController.billNo,inputType: TextInputType.number),
              textFieldWidget(
                  label: "تاریخ",
                  imgPath: "assets/icons/calendar.png",
                  controller: expenseController.startDate,onPressed:()=> selectDate(expenseController.startDate)),
              textFieldWidget(
                  label: "پیسے",
                  inputType: TextInputType.number,
                  imgPath: "assets/icons/profits.png",
                  controller: expenseController.price),
              dropDownTextFieldWidget(
                label: "خرچه نوم غوره کړئ",
                imgPath: "assets/icons/id.png",
                dropDownList: dropDownList,
                onChanged: (value) {
                  // Update the expenseType in the ExpenseController
                  expenseController.expenseType = value;
                },
              ),
              textFieldWidget(
                  label: "تفصيل",
                  imgPath: "assets/icons/note.png",
                  maxLine: 3,
                  controller: expenseController.note),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: CustomButton(onPressed: () {
            expenseController.addExpense();
            setState(() {});
            Get.back();
          }),
        )
      ],
    );
  }
}
