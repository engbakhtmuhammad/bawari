import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:bawari/view/dues/add_dues.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/customer_controller.dart';
import '../../controller/duesController.dart';
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
    List<String?> customerNames = await duesController.getDuesNames();
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

  void assignTransactionData(String id) async {
    transactionsList = await duesController.getTransactionsList(id);
    setState(() {});
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
                duesController.customerName.toString(),
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
                    controller: duesController.date),
                dropDownTextFieldWidget(
                  label: "گراک نوم غوره کړئ",
                  imgPath: "assets/icons/id.png",
                  dropDownList: dropDownList,
                  onChanged: (value) async {
                    // Update the expenseType in the ExpenseController
                    duesController.customerName = value;
                    var duesModel =
                        await duesController.getDuesByName(value);
                        transactionsList= await duesController.getTransactionsList(duesModel!.id.toString());
                    duesController.customerId.text = duesModel.id.toString();
                    duesController.address.text = duesModel.dues![0].address.toString();
                    duesController.dues.text = duesController.getTotalDues(transactionsList).toString();
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
                          duesController.addRecieveEntry();
                        },
                        icon: "assets/icons/file_sync.png",
                      ),
                    ),
                    Text(
                      "Total: ${duesController.getTotalDues(transactionsList)}",
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
            // Obx(() {
              // duesController.getDuesEntries();
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
                    "توثل بقايا  ${duesController.getTotalDues(transactionsList)}",
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
