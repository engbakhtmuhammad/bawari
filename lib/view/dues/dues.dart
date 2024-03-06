import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:bawari/view/dues/add_dues.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/customer_controller.dart';
import '../../controller/duesController.dart';
import '../../controller/dues_controller.dart';
import '../../model/dues_model.dart';
import '../../utils/constants.dart';
import '../widgets/custom_btn.dart';

class DueScreen extends StatefulWidget {
  const DueScreen({super.key});

  @override
  State<DueScreen> createState() => _DueScreenState();
}

class _DueScreenState extends State<DueScreen> {
  DuesController duesController = Get.put(DuesController());
  CustomerController customerController = Get.put(CustomerController());
  // Example data, you can replace it with your dynamic data
  List<String> tableColumns = [
    "را باندی نوم",
    "کرضہ",
    "وصول",
    // "حوالا ادرس",
    // "تاریخ",
  ];
  List<DropdownMenuItem<String>> dropDownList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCustomers();
    });
  }

// Inside a method where you fetch customers, such as in the initState method
  void fetchCustomers() async {
    List<String?> customerNames = await customerController.getCustomerNames();
    print('Customer Names: $customerNames');

    // Update the dropDownList based on the fetched customer names
    dropDownList = customerNames.map((customerName) {
      return DropdownMenuItem(
        alignment: Alignment.centerLeft,
        value: customerName,
        child: Text(customerName!),
      );
    }).toList();
    print(dropDownList.length);

    // Ensure to update the state to reflect changes in the UI
    if (mounted) {
      setState(() {});
    }
  }

  String calculateTotal() {
    try {
      int duesAmount = duesController.dues.text.isEmpty
          ? 0
          : int.parse(duesController.dues.text);
      int receivedAmount = duesController.received.text.isEmpty
          ? 0
          : int.parse(duesController.received.text);

      return (duesAmount - receivedAmount).toString();
    } catch (e) {
      // Handle the exception (e.g., log it)
      print("Error calculating total: $e");
      return 'Error';
    }
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
                    controller: duesController.date),
                dropDownTextFieldWidget(
                  label: "گراک نوم غوره کړئ",
                  imgPath: "assets/icons/id.png",
                  dropDownList: dropDownList,
                  onChanged: (value) async {
                    // Update the expenseType in the ExpenseController
                    duesController.customerName = value;
                    // var customer =
                    //     await duesController.getCustomerByName(value);
                    // duesController.customerId.text = customer!.id.toString();
                    // duesController.address.text = customer.address.toString();
                    // duesController.dues.text = customer.dues.toString();
                  },
                ),
                textFieldWidget(
                    label: "حوالا ادرس",
                    imgPath: "assets/icons/price.png",
                    controller: duesController.address),
                textFieldWidget(
                    label: "را باندی",
                    imgPath: "assets/icons/dues.png",
                    controller: duesController.dues),
                textFieldWidget(
                    label: "وصول",
                    imgPath: "assets/icons/income.png",
                    controller: duesController.received),
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
                          
                          // duesController.addToSubDueList(customerController.ger);
                        },
                        icon: "assets/icons/file_sync.png",
                      ),
                    ),
                    Text(
                      "Total: ${calculateTotal()}",
                      style: boldTextStyle(),
                    )
                  ],
                ),
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
                        rows: [
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
                                // DataCell(
                                //   Text(
                                //     DateFormat('yyyy-MM-dd').format(
                                //         duesController.duesList[row].date!),
                                //     textAlign: TextAlign.center,
                                //     style: primaryTextStyle(size: 14),
                                //   ),
                                // ),
                                // DataCell(
                                //   Text(
                                //     duesController.duesList[row].address
                                //         .toString(),
                                //     textAlign: TextAlign.center,
                                //     style: primaryTextStyle(size: 14),
                                //   ),
                                // ),
                                //7
                                DataCell(
                                  Text(
                                    duesController.duesList[row].received
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //6
                                DataCell(
                                  Text(
                                    duesController.duesList[row].dues
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //5
                                DataCell(
                                  Text(
                                    duesController.duesList[row].customerName
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
        onPressed: () => Get.to(AddDueScreen()),
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
