import 'package:bawari/controller/credit_controller.dart';
import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/customer_controller.dart';
import '../../utils/constants.dart';
import '../widgets/custom_btn.dart';

class CreditScreen extends StatefulWidget {
  const CreditScreen({super.key});

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {


CreditController creditController = Get.put(CreditController());
List<String> tableColumns = [
    "را باندی نوم",
    "پیسے",
    "تاریخ",
    "حوالا ادرس",
  ];
  List<DropdownMenuItem<String>> dropDownList = [];
  var transactionsList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCustomers();
    });
  }

// Inside a method where you fetch customers, such as in the initState method
  void fetchCustomers() async {
    List<String?> customerNames = await creditController.getCreditNames();
    // print('Customer Names: $customerNames');

    // Update the dropDownList based on the fetched customer names
    dropDownList = customerNames.map((customerName) {
      return DropdownMenuItem(
        alignment: Alignment.centerLeft,
        value: customerName,
        child: Text(customerName!),
      );
    }).toList();
    // print(dropDownList.length);

    // Ensure to update the state to reflect changes in the UI
    if (mounted) {
      setState(() {});
    }
  }


  List<DataRow> buildDataRows()  {
    List<DataRow> rows = [];
      for (var subRow = 0; subRow < transactionsList.length; subRow++) {
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
                transactionsList[subRow].address.toString(),
                textAlign: TextAlign.center,
                style: primaryTextStyle(size: 14),
              ),
            ),
            DataCell(
              Text(
                DateFormat('yyyy-MM-dd').format(transactionsList[subRow].date),
                textAlign: TextAlign.center,
                style: primaryTextStyle(size: 14),
              ),
            ),
            DataCell(
              Text(
                transactionsList[subRow].price.toString(),
                textAlign: TextAlign.center,
                style: primaryTextStyle(size: 14,color: transactionsList[subRow].price < 0 ? Colors.red :blackColor),
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
    fetchCustomers();
    return Scaffold(
      appBar: appBarWidget(
        title: "را باندی",
      ),
      drawer: drawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            backContainerWidget(
                child: Column(
              children: [
                textFieldWidget(
                    label: "تاریخ",
                    imgPath: "assets/icons/calendar.png",
                    controller: creditController.date),
                dropDownTextFieldWidget(
                  label: "گراک نوم غوره کړئ",
                  imgPath: "assets/icons/id.png",
                  dropDownList: dropDownList,
                  onChanged: (value) async {
                    // Update the expenseType in the ExpenseController
                    creditController.customerName = value;
                    var duesModel =
                        await creditController.getCreditByName(value);
                        transactionsList= await creditController.getTransactionsList(duesModel!.id.toString());
                    creditController.customerId.text = duesModel.id.toString();
                    creditController.address.text = duesModel.credits![0].address.toString();
                    creditController.credits.text = creditController.getTotalCredits(transactionsList).toString();
                  },
                ),
                textFieldWidget(
                    label: "حوالا ادرس",
                    imgPath: "assets/icons/price.png",
                    controller: creditController.address),
                    SizedBox(height: defaultPadding,),
                    textFieldWidget(
                    label: "را باندی",
                    imgPath: "assets/icons/dues.png",
                    controller: creditController.credits),
                textFieldWidget(
                    label: "وصول",
                    imgPath: "assets/icons/income.png",
                    controller: creditController.received),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .25,
                      child: CustomButton(
                        onPressed: () {},
                        icon: "assets/icons/print.png",
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .25,
                      child: CustomButton(
                        onPressed: () {
                          creditController.addRecieveEntry();
                        },
                        icon: "assets/icons/file_sync.png",
                      ),
                    ),
                    Text(
                      "Total: ${creditController.getTotalCredits(transactionsList)}",
                      style: boldTextStyle(),
                    )
                  ],
                ),
              
                // Container(
                //     height: 50,
                //     width: double.infinity,
                //     color: secondaryColor,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         SizedBox(
                //           width: MediaQuery.of(context).size.width * .7,
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //             children: [
                //               Text(
                //                 "data",
                //                 style: boldTextStyle(color: whiteColor),
                //               ),
                //               Text(
                //                 "data",
                //                 style: boldTextStyle(color: whiteColor),
                //               ),
                //             ],
                //           ),
                //         ),
                //         SizedBox(
                //           width: defaultIconsSize,
                //         )
                //       ],
                //     )),
                // Padding(
                //   padding: EdgeInsets.only(top: defaultPadding),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       SizedBox(
                //         width: MediaQuery.of(context).size.width * .7,
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //           children: [
                //             Container(
                //               height: 30,
                //               width: MediaQuery.of(context).size.width * .3,
                //               decoration: BoxDecoration(
                //                   borderRadius:
                //                       BorderRadius.circular(defaultRadius),
                //                   border: Border.all(color: greyColor)),
                //               child: Center(child: Text("Bill")),
                //             ),
                //             Container(
                //               height: 30,
                //               width: MediaQuery.of(context).size.width * .3,
                //               decoration: BoxDecoration(
                //                   borderRadius:
                //                       BorderRadius.circular(defaultRadius),
                //                   border: Border.all(color: greyColor)),
                //               child: Center(child: Text("Bill")),
                //             ),
                //           ],
                //         ),
                //       ),
                //       GestureDetector(
                //         child: Image.asset(
                //           "assets/icons/trash.png",
                //           width: defaultIconsSize,
                //           height: defaultIconsSize,
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                // Divider(),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     SizedBox(
                //       width: MediaQuery.of(context).size.width * .25,
                //       child: CustomButton(
                //         onPressed: () {},
                //         icon: "assets/icons/print.png",
                //       ),
                //     ),
                //     SizedBox(
                //       width: MediaQuery.of(context).size.width * .25,
                //       child: CustomButton(
                //         onPressed: () {},
                //         icon: "assets/icons/file_sync.png",
                //       ),
                //     ),
                //     Text(
                //       "Total: 500",
                //       style: boldTextStyle(),
                //     )
                //   ],
                // ),
                // const SizedBox(height: 10,),
                // CustomButton(onPressed: (){},label: "سابقہ بل وصولی",)
              ],
            )),
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultHorizontalPadding),
                  child: Text(
                    "راناندی کهاته",
                    style: boldTextStyle(),
                  ),
                )),
            // Obx(() {
              // creditController.getDuesEntries();
               SizedBox(
                  height: transactionsList.length * 50 + 60,
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
                    "توثل بقايا  ${creditController.getTotalCredits(transactionsList)}",
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
