import 'package:bawari/controller/bill_controller.dart';
import 'package:bawari/controller/credit_controller.dart';
import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:bawari/view/invoice/cash_invoice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/constants.dart';
import '../invoice/file_handle_api.dart';
import '../widgets/custom_btn.dart';

class CreditScreen extends StatefulWidget {
  const CreditScreen({super.key});

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CreditController creditController = Get.put(CreditController());
  BillNumberController billNumberController = Get.put(BillNumberController());
  var _searchController = TextEditingController();

  List<String> tableColumns = [
    "بل نمبر",
    "ور باندی نوم",
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
      fetchCredits();
    });
  }

// Inside a method where you fetch customers, such as in the initState method
  void fetchCredits() async {
    billNumberController.getBillNumber();
    List<String?> customerNames = await creditController.getCreditNames();
    // Update the dropDownList based on the fetched customer names
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

  List<DataRow> buildDataRows() {
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
              style: primaryTextStyle(
                  size: 14,
                  color: transactionsList[subRow].price < 0
                      ? Colors.red
                      : blackColor),
            ),
          ),
          DataCell(
            Text(
              creditController.customerName.toString(),
              textAlign: TextAlign.center,
              style: primaryTextStyle(size: 14),
            ),
          ),
          DataCell(
            Text(
              transactionsList[subRow].billNo.toString(),
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
    fetchCredits();
    return Scaffold(
      key: scaffoldKey,
      appBar: appBarWidget(
          title: "وصولی",
          openDrawer: () => scaffoldKey.currentState?.openDrawer()),
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
                    // Update the expenseType in the creditController
                    creditController.customerName = value;
                    var duesModel =
                        await creditController.getCreditByName(value);
                    transactionsList = await creditController
                        .getTransactionsList(duesModel!.customerId.toString(),
                            date: DateTime.now());
                    creditController.customerId.text = duesModel.id.toString();
                    creditController.address.text =
                        duesModel.credits![0].address.toString();
                    creditController.credits.text = creditController
                        .getTotalCredits(transactionsList)
                        .toString();
                  },
                ),
                textFieldWidget(
                    label: "حوالا ادرس",
                    imgPath: "assets/icons/price.png",
                    controller: creditController.address),
                textFieldWidget(
                    label: "ور باندی",
                    imgPath: "assets/icons/dues.png",
                    isReadOnly: true,
                    controller: creditController.credits),
                textFieldWidget(
                    label: "وصول",
                    imgPath: "assets/icons/income.png",
                    controller: creditController.received,
                    inputType: TextInputType.number),
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
                //         onPressed: () {
                //           creditController.addRecieveEntry();
                //         },
                //         icon: "assets/icons/file_sync.png",
                //       ),
                //     ),
                //     Text(
                //       "Total: ${creditController.getTotalCredits(transactionsList)}",
                //       style: boldTextStyle(),
                //     )
                //   ],
                // ),

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
                //                 "پیسے",
                //                 style: boldTextStyle(color: whiteColor),
                //               ),
                //               Text(
                //                 "بل نمبر",
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
                //               child: Center(
                //                   child: TextField(
                //                 textAlign: TextAlign.center,
                //                 controller: creditController.received,
                //                 keyboardType: TextInputType.number,
                //                 decoration: InputDecoration(
                //                   border: InputBorder.none,
                //                 ),
                //               )),
                //             ),
                //             Container(
                //               height: 30,
                //               width: MediaQuery.of(context).size.width * .3,
                //               decoration: BoxDecoration(
                //                   borderRadius:
                //                       BorderRadius.circular(defaultRadius),
                //                   border: Border.all(color: greyColor)),
                //               child: Center(
                //                   child: TextField(
                //                 textAlign: TextAlign.center,
                //                 controller: billController,
                //                 keyboardType: TextInputType.number,
                //                 decoration: InputDecoration(
                //                   border: InputBorder.none,
                //                 ),
                //               )),
                //             ),
                //           ],
                //         ),
                //       ),
                //       GestureDetector(
                //         onTap: () =>alertDialog(title: "ایا تاسو ډاډه یاست چې ساحې پاکې کړئ",onPressed: () {
                //           billController.clear();
                //           creditController.received.clear();
                //           Get.back();
                //         }),
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
                //         onPressed: () async {
                //           final invoice = Invoice(
                //       supplier: Supplier(
                //         name: 'Sarah Field',
                //         address: 'Sarah Street 9, Beijing, China',
                //         paymentInfo: 'https://paypal.me/sarahfieldzz',
                //       ),
                //       customer: Customer(
                //         name: 'Apple Inc.',
                //         address: 'Apple Street, Cupertino, CA 95014',
                //       ),
                //       info: InvoiceInfo(
                //         date: DateTime.now(),
                //         // dueDate: dueDate,
                //         description: 'My description...',
                //         number: '${DateTime.now().year}-9999', dueDate: DateTime.now(),
                //       ),
                //       items: [
                //         InvoiceItem(
                //           description: 'Coffee',
                //           date: DateTime.now(),
                //           quantity: 3,
                //           vat: 0.19,
                //           unitPrice: 5.99,
                //         ),
                //         InvoiceItem(
                //           description: 'Water',
                //           date: DateTime.now(),
                //           quantity: 8,
                //           vat: 0.19,
                //           unitPrice: 0.99,
                //         ),
                //         InvoiceItem(
                //           description: 'Orange',
                //           date: DateTime.now(),
                //           quantity: 3,
                //           vat: 0.19,
                //           unitPrice: 2.99,
                //         ),
                //         InvoiceItem(
                //           description: 'Apple',
                //           date: DateTime.now(),
                //           quantity: 8,
                //           vat: 0.19,
                //           unitPrice: 3.99,
                //         ),
                //         InvoiceItem(
                //           description: 'Mango',
                //           date: DateTime.now(),
                //           quantity: 1,
                //           vat: 0.19,
                //           unitPrice: 1.59,
                //         ),
                //         InvoiceItem(
                //           description: 'Blue Berries',
                //           date: DateTime.now(),
                //           quantity: 5,
                //           vat: 0.19,
                //           unitPrice: 0.99,
                //         ),
                //         InvoiceItem(
                //           description: 'Lemon',
                //           date: DateTime.now(),
                //           quantity: 4,
                //           vat: 0.19,
                //           unitPrice: 1.29,
                //         ),
                //       ],
                //     );

                //     final pdfFile = await PdfInvoiceApi.generate(invoice);

                //     PdfApi.openFile(pdfFile);
                //         },
                //         icon: "assets/icons/print.png",
                //       ),
                //     ),
                //     SizedBox(
                //       width: MediaQuery.of(context).size.width * .25,
                //       child: CustomButton(
                //         onPressed: () {creditController.addRecieveEntry();},
                //         icon: "assets/icons/file_sync.png",
                //       ),
                //     ),
                //     Text(
                //       "Total: ${creditController.getTotalCredits(transactionsList)}",
                //       style: boldTextStyle(),
                //     )
                //   ],
                // ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  onPressed: () {
                    creditController.addRecieveEntry();
                  },
                  label: "سابقہ بل وصولی",
                  icon: "assets/icons/file_sync.png",
                ),
                CustomButton(
                  onPressed: () async {
                    final pdfFile = await CashInvoicePdf.generate(
                        cash: transactionsList, name: creditController.customerName);
                    // opening the pdf file
                    FileHandleApi.openFile(pdfFile);
                    // Get.to(InvoiceScreen());
                  },
                  label: "بل پرنٹ",
                  icon: "assets/icons/print.png",
                )
              ],
            )),
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultHorizontalPadding),
                  child: Text(
                    "ورباندی کهاته",
                    style: boldTextStyle(),
                  ),
                )),
            // Obx(() {
            // creditController.getDuesEntries();
            StreamBuilder(
                stream: creditController
                    .getCreditEntries(date: DateTime.now())
                    .asStream(),
                builder: (context, snapshot) {
                  return SizedBox(
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
                              rows: buildDataRows()),
                        ],
                      ));
                }),
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
                    style: boldTextStyle(color: whiteColor),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          creditController.credits.clear();
          showAddCreditDialog();
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void showAddCreditDialog() {
    Get.defaultDialog(
      title: 'پہ خلکو باندے',
      content: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              dropDownTextFieldWidget(
                label: "گراک نوم غوره کړئ",
                imgPath: "assets/icons/id.png",
                dropDownList: dropDownList,
                onChanged: (value) {
                  creditController.customerName = value;
                },
              ),
              textFieldWidget(
                  label: "پیسے",
                  inputType: TextInputType.number,
                  imgPath: "assets/icons/profits.png",
                  controller: creditController.credits),
              textFieldWidget(
                  label: "حوالا ادرس",
                  imgPath: "assets/icons/note.png",
                  maxLine: 3,
                  controller: creditController.address),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: CustomButton(onPressed: () {
            creditController.addCreditEntry().then((value) => Get.back());
            setState(() {});
          }),
        )
      ],
    );
  }
}
