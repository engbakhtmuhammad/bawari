import 'package:bawari/controller/customer_controller.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:bawari/view/widgets/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  CustomerController customerController = Get.put(CustomerController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isActive=true;
  // Example data, you can replace it with your dynamic data
  List<String> tableColumns = [
    "کسٹمر کا نمبر",
    "کسٹمر کا نام",
    "کسٹمر کا پتہ",
    "کسٹمر کا فون",
    "قیمت فروخت",
    "دی او کھ نا"
  ];
  List<List<String>> tableRows = [
    ["باوری لمیت (1 لیتر)", "5", "5", "12", "112", "12453"],
    ["باوری لمیت (1 لیتر)", "5", "5", "12", "112", "12453"],
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBarWidget(title: "کسٹمر",openDrawer: ()=>scaffoldKey.currentState?.openDrawer()),
      drawer: drawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            backContainerWidget(
                child: Column(
              children: [
                textFieldWidget(
                    label: "کسٹمر کا نمبر",
                    imgPath: "assets/icons/note.png",
                    inputType: TextInputType.number,
                    controller: customerController.customerNo),
                textFieldWidget(
                    label: "کسٹمر کا نام",
                    imgPath: "assets/icons/id.png",
                    controller: customerController.name),
                textFieldWidget(
                    label: "کسٹمر کا پتہ",
                    imgPath: "assets/icons/address.png",
                    controller: customerController.address),
                textFieldWidget(
                    label: "کسٹمر کا فون",
                    imgPath: "assets/icons/phone.png",
                    inputType: TextInputType.phone,
                    controller: customerController.phone),
                textFieldWidget(
                    label: "قیمت فروخت",
                    imgPath: "assets/icons/income.png",
                    inputType: TextInputType.number,
                    controller: customerController.price),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'is Active',
                      style: primaryTextStyle(),
                    ),
                    const SizedBox(width: 8),
                    Checkbox(
                      value: isActive,
                      tristate: true,
                      onChanged: (value) {
                        setState(() {
                          isActive = value!;
                          customerController.isActive = value;
                        });
                      },
                    ),
                  ],
                ),
                CustomButton(
                  onPressed: () {
                    customerController.addCustomer();
                  },
                  icon: "assets/icons/file_sync.png",
                )
              ],
            )),
            // TableWidget(tableRows: tableRows, tableColumns: tableColumns),
            Obx(() {
              customerController.getCustomers();
              return SizedBox(
                  height: customerController.customerList.length * 50 + 60,
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

// Inside your DataRow
                        rows: [
                          for (var row = 0;
                              row < customerController.customerList.length;
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
                                    customerController
                                        .customerList[row].isActive
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //7
                                DataCell(
                                  Text(
                                    customerController.customerList[row].price
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //6
                                DataCell(
                                  Text(
                                    customerController.customerList[row].phone
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //5
                                DataCell(
                                  Text(
                                    customerController.customerList[row].address
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //4
                                DataCell(
                                  Text(
                                    customerController.customerList[row].name
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //3
                                DataCell(
                                  Text(
                                    customerController
                                        .customerList[row].customerNo
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
                                        padding:  EdgeInsets.only(left: defaultPadding),
                                        child: Image.asset("assets/icons/trash.png"),
                                      ),
                                      onTap: ()=>alertDialog(title: "ایا تاسو ډاډه یاست چې پیرودونکي حذف کړئ",onPressed: () {
                                        // Add your delete logic here using customerController
                                        customerController.deleteCustomer(
                                            customerController
                                                .customerList[row].id
                                                .toString());
                                                Get.back();
                                      }),
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
