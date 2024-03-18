import 'package:bawari/controller/goods_controller.dart';
import 'package:bawari/controller/purchase_controller.dart';
import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:bawari/view/invoice/mobile_invoice.dart';
import 'package:bawari/view/invoice/purchase_invoice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../utils/constants.dart';
import '../invoice/file_handle_api.dart';
import '../invoice/pdf_invoice_api.dart';
import '../widgets/custom_btn.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  PurchaseController purchaseController = Get.put(PurchaseController());
  GoodsController goodsController = Get.put(GoodsController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String goodsId = '';

// Example data, you can replace it with your dynamic data
  List<String> tableColumns = [
    "سامان",
    "کارتن تعداد",
    "في كارتن تعداد",
    "مکمل تعداد",
    "في تعدادقيمت",
    "مکمل تعدادقيمت",
    "تاریخ",
  ];
  List<DropdownMenuItem<String>> goodsDropDownList = [];
  var suppplierDropDownList = const [
    DropdownMenuItem(
      alignment: Alignment.centerLeft,
      value: "China",
      child: Text("China"),
    ),
    DropdownMenuItem(
      alignment: Alignment.centerLeft,
      value: "Korian",
      child: Text("Korian"),
    ),
    DropdownMenuItem(
      alignment: Alignment.centerLeft,
      value: "Japan",
      child: Text("Japan"),
    ),
  ];

  final tableData = [
    [
      'Coffee',
      '7',
      '\$ 5',
      '1 %',
      '\$ 35',
    ],
    [
      'Blue Berries',
      '5',
      '\$ 10',
      '2 %',
      '\$ 50',
    ],
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchGoods();
    });
  }

// Inside a method where you fetch customers, such as in the initState method
  void fetchGoods() async {
    List<String?> goodsName = await goodsController.getGoodsNames();

    goodsDropDownList = goodsName.map((goods) {
      return DropdownMenuItem(
        alignment: Alignment.centerLeft,
        value: goods,
        child: Text(goods!),
      );
    }).toList();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchGoods();
    return Scaffold(
      key: scaffoldKey,
      appBar: appBarWidget(
        title: "سامان خرید",
        openDrawer: () => scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: drawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            billAndDateWidget(
                onPressed2: () => selectDate(purchaseController.date),
                dateController: purchaseController.date,
                billController: purchaseController.bill),
            backContainerWidget(
              child: Column(
                children: [
                  dropDownTextFieldWidget(
                    label: "سپلایر نوم غوره کړئ",
                    imgPath: "assets/icons/name.png",
                    dropDownList: suppplierDropDownList,
                    onChanged: (value) async {},
                  ),
                  dropDownTextFieldWidget(
                    label: "سامان نوم غوره کړئ",
                    imgPath: "assets/icons/name.png",
                    dropDownList: goodsDropDownList,
                    onChanged: (value) async {
                      // Update the expenseType in the ExpenseController
                      purchaseController.name = value;
                      var goodsModel =
                          await goodsController.getGoodsByName(value);
                      goodsId = goodsModel!.id!;
                      purchaseController.goodsNo.text =
                          goodsModel.goodsNo!.toString();
                      purchaseController.perCartonCount.text =
                          goodsModel.perCartonCount.toString();
                      purchaseController.price.text =
                          goodsModel.purchasePrice.toString();
                    },
                  ),
                  textFieldWidget(
                      label: "نوٹ",
                      imgPath: "assets/icons/note.png",
                      maxLine: 4,
                      controller: purchaseController.note),
                  // textFieldWidget(
                  //     label: "سامان نمبر",
                  //     imgPath: "assets/icons/number.png",
                  //     inputType: TextInputType.number,
                  //     controller: purchaseController.goodsNo),
                  textFieldWidget(
                      label: "کارٹن تعداد",
                      imgPath: "assets/icons/cortons.png",
                      inputType: TextInputType.number,
                      controller: purchaseController.cartonCount,
                      onChange: (value) {
                        purchaseController.totalCount.text = (int.parse(value) *
                                int.parse(
                                    purchaseController.perCartonCount.text))
                            .toString();
                      }),
                  textFieldWidget(
                      label: "فی کارٹن تعداد",
                      imgPath: "assets/icons/count.png",
                      inputType: TextInputType.number,
                      controller: purchaseController.perCartonCount),
                  textFieldWidget(
                      label: "جمله تعداد",
                      imgPath: "assets/icons/total.png",
                      inputType: TextInputType.number,
                      isReadOnly: true,
                      controller: purchaseController.totalCount),
                  textFieldWidget(
                      label: "قیمت",
                      imgPath: "assets/icons/price.png",
                      inputType: TextInputType.number,
                      prefixText: calculateTotal(),
                      controller: purchaseController.price),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: CustomButton(
                      onPressed: () {
                        goodsController.updateGoodsCount(goodsId,
                            int.parse(purchaseController.cartonCount.text));
                        purchaseController.addPurchase();
                      },
                    ),
                  )
                ],
              ),
            ),
            Obx(() {
              purchaseController.getPurchasesBetweenDates();
              return SizedBox(
                  height: purchaseController.purchaseList.length * 50 + 60,
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
                              row < purchaseController.purchaseList.length;
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
                                    "${DateFormat('yyyy-MM-dd').format(purchaseController.purchaseList[row].date!)}",
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //7
                                DataCell(
                                  Text(
                                    "${int.parse(purchaseController.purchaseList[row].price.toString()) * int.parse(purchaseController.purchaseList[row].totalCount.toString())}",
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //6
                                DataCell(
                                  Text(
                                    purchaseController.purchaseList[row].price
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //5
                                DataCell(
                                  Text(
                                    purchaseController
                                        .purchaseList[row].totalCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //4
                                DataCell(
                                  Text(
                                    purchaseController
                                        .purchaseList[row].perCartonCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //3
                                DataCell(
                                  Text(
                                    purchaseController
                                        .purchaseList[row].cartonCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    purchaseController.purchaseList[row].name
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                      child: GestureDetector(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: defaultPadding),
                                            child: Image.asset(
                                                "assets/icons/print.png"),
                                          ),
                                         onTap: () async {
                                            final pdfFile = await PurchaseInvoicePdf.generate(purchase: purchaseController.purchaseList[row]);
                                            // opening the pdf file
                                            FileHandleApi.openFile(pdfFile);
                                            // Get.to(InvoiceScreen());
                                          })),
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
            // TableWidget(tableRows: purchaseController.purchaseList, tableColumns: tableColumns),
            const SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
        width: double.infinity,
        color: secondaryColor,
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${purchaseController.getTotalPrice()}",
                    style: primaryTextStyle(color: whiteColor),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .3,
                    child: Text(
                      "ٹوٹل بل",
                      textAlign: TextAlign.end,
                      style: boldTextStyle(color: whiteColor),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${goodsController.getTotalCartonCount()}",
                    style: primaryTextStyle(color: whiteColor),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .3,
                    child: Text(
                      "کارٹن تعداد",
                      textAlign: TextAlign.end,
                      style: boldTextStyle(color: whiteColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String calculateTotal() {
    try {
      int price = int.parse(purchaseController.price.text ?? '0');
      int totalCount = int.parse(purchaseController.totalCount.text ?? '0');
      int total = price * totalCount;

      return "Total: $total";
    } catch (e) {
      // Handle the case where parsing fails
      print("Error: Invalid input. Please enter valid numbers.");
      return "Total: N/A";
    }
  }
}
