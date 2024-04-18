import 'package:bawari/controller/customer_controller.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/dues_controller.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../widgets/custom_btn.dart';

class AddDueScreen extends StatefulWidget {
  const AddDueScreen({super.key});

  @override
  State<AddDueScreen> createState() => _AddDueScreenState();
}

class _AddDueScreenState extends State<AddDueScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DuesController duesController = Get.put(DuesController());
  CustomerController customerController = Get.put(CustomerController());
  // Example data, you can replace it with your dynamic data
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
    List<String?> customerNames = await customerController.getCustomerNames();
    dropDownList = customerNames.map((customerName) {
      return DropdownMenuItem(
        alignment: Alignment.centerLeft,
        value: customerName,
        child: Text(customerName!),
      );
    }).toList();
    if (mounted) {
      setState(() {});
    }
  }

  void assignTransactionData(String id) async {
    transactionsList = await duesController.getTransactionsList(id);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    
    fetchCustomers();
    return Scaffold(
      key: scaffoldKey,
      appBar: appBarWidget(
        title: "را باندی",openDrawer: () => scaffoldKey.currentState?.openDrawer(),
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
                    controller: duesController.date,
                    onPressed: () => selectDate(duesController.date),
                    inputType: TextInputType.datetime),
                dropDownTextFieldWidget(
                  label: "گراک نوم غوره کړئ",
                  imgPath: "assets/icons/id.png",
                  dropDownList: dropDownList,
                  onChanged: (value) {
                    // Update the expenseType in the ExpenseController
                    duesController.customerName = value;
                    duesController.customerId.text =
                        customerController.getCustomerIdByName(value)!;
                  },
                ),
                textFieldWidget(
                    label: "حوالا ادرس",
                    imgPath: "assets/icons/price.png",
                    controller: duesController.address),
                textFieldWidget(
                    label: "را باندی",
                    imgPath: "assets/icons/dues.png",
                    inputType: TextInputType.number,
                    controller: duesController.dues),
                SizedBox(
                  height: defaultPadding,
                ),
                CustomButton(
                  onPressed: () {
                    duesController.addDuesEntry();
                  },
                ),
              ],
            )),
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultHorizontalPadding),
                  child: Text(
                    "را باندی کهاته",
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
