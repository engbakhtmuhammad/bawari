import 'package:bawari/controller/credit_controller.dart';
import 'package:bawari/controller/customer_controller.dart';
import 'package:bawari/controller/goods_controller.dart';
import 'package:bawari/controller/purchase_controller.dart';
import 'package:bawari/controller/sale_controller.dart';
import 'package:bawari/controller/savings_controller.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/view/invoice/sale_invoice.dart';
import 'package:flutter/material.dart';
import 'package:bawari/utils/text_styles.dart';
import '../invoice/file_handle_api.dart';
import '../widgets/custom_btn.dart';
import 'package:get/get.dart';
import 'package:bawari/utils/colors.dart';
import '../../utils/constants.dart';
import '../widgets/sell_container.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  SaleController saleController = Get.put(SaleController());
  GoodsController goodsController = Get.put(GoodsController());
  CustomerController customerController = Get.put(CustomerController());
  CreditController creditController = Get.put(CreditController());
  PurchaseController purchaseController = Get.put(PurchaseController());
  SavingsController savingsController = Get.put(SavingsController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var _searchController = TextEditingController();
  int totalCarton = 0;
  int? totalBill = 0;
  int remainingBill=0;
  int received=0;
  String customerId = '';
  int purchasePrice=0;
  int savings=0;
  int cartonCount=0;

// Example data, you can replace it with your dynamic data
  List<String> tableColumns = [
    "سامان",
    "پیس تعداد",
    "کارتن تعداد",
    "في كارتن تعداد",
    "جمله تعداد",
    "في تعدادقيمت",
    "مکمل تعدادقيمت",
  ];

  List<DropdownMenuItem<String>> goodsDropDownList = [];
  List<DropdownMenuItem<String>> customerDropDownList = [];
  var transactionsList = [];

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
    List<String?> customerName = await customerController.getCustomerNames();

    goodsDropDownList = goodsName.map((goods) {
      return DropdownMenuItem(
        alignment: Alignment.centerLeft,
        value: goods,
        child: Text(goods!),
      );
    }).toList();

    customerDropDownList = customerName.map((customer) {
      return DropdownMenuItem(
        alignment: Alignment.centerLeft,
        value: customer,
        child: Text(customer!),
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
        title: "سامان فروخت",
        openDrawer: () => scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: drawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            billAndDateWidget(
                dateController: saleController.date,
                onPressed2: () => selectDate(saleController.date),
                billController: saleController.bill),
            backContainerWidget(
              child: Column(
                children: [
                  dropDownTextFieldWidget(
                      label: "گراک نوم غوره کړئ",
                      imgPath: "assets/icons/name.png",
                      dropDownList: customerDropDownList,
                      onChanged: (value) async {
                        creditController.customerName = value;
                        var creditModel =
                            await customerController.getCustomerByName(value);
                        creditController.customerId.text =
                            creditModel!.id.toString();
                        customerId = creditModel.id.toString();
                        print('>>>>>>>>>>>>>>>ID CUstomer: $customerId');
                        saleController.customerId = creditModel.id.toString();
                        saleController.customerName = value;
                      }),
                  dropDownTextFieldWidget(
                    label: "سامان نوم غوره کړئ",
                    imgPath: "assets/icons/name.png",
                    dropDownList: goodsDropDownList,
                    onChanged: (value) async {
                      // Update the expenseType in the ExpenseController
                      saleController.name = value;
                      var goodsModel =
                          await goodsController.getGoodsByName(value);
                      saleController.goodsNo.text =
                          goodsModel!.goodsNo!.toString();
                          cartonCount=goodsModel.cartonCount!;
                      saleController.perCartonCount.text =
                          goodsModel.perCartonCount.toString();
                      saleController.price.text =
                          goodsModel.salePrice.toString();
                      // saleController.totalPrice.text =
                      //     (int.parse(saleController.cartonCount.text) *
                      //             int.parse(saleController.price.text))
                      //         .toString();
                    },
                  ),
                  // textFieldWidget(
                  //     label: "سامان نمبر",
                  //     imgPath: "assets/icons/number.png",
                  //     inputType: TextInputType.number,
                  //     controller: saleController.goodsNo),
                  textFieldWidget(
                    label: "پیس تعداد",
                    imgPath: "assets/icons/count.png",
                    inputType: TextInputType.number,
                    controller: saleController.pieceCount,
                  ),
                  textFieldWidget(
                      label: "کارٹن تعداد",
                      imgPath: "assets/icons/cortons.png",
                      inputType: TextInputType.number,
                      controller: saleController.cartonCount,
                      onChange: (value) async {
                        print("Received value: $value");
                        var goodsModel = await goodsController
                            .getGoodsByName(saleController.name);
                        try {
                          int cartCount = int.tryParse(value) ?? 1;
                          int perCartCount = goodsModel!.perCartonCount!;
                          int totalPrice = goodsModel.salePrice!;

                          print(
                              "Per Carton Count: ${goodsController.perCartonCount.text}");
                          print(
                              "Sale Price: ${goodsController.salePrice.text}");

                          saleController.totalPrice.text =
                              ((cartCount * perCartCount +
                                          int.parse(
                                              saleController.pieceCount.text)) *
                                      totalPrice)
                                  .toString();
                          saleController.totalCount.text =
                              (cartCount * perCartCount +
                                      int.parse(saleController.pieceCount.text))
                                  .toString();
                                  totalBill=int.parse(saleController.totalPrice.text);
                                  totalCarton=int.parse(saleController.cartonCount.text);
                          saleController.update();

                          print(
                              "Total Price: ${saleController.totalPrice.text}, Total Count: ${saleController.totalCount.text}");
                        } catch (e) {
                          print("Error parsing values: $e");
                        }
                      },
                      prefixText:
                          "$cartonCount  :کارٹن تعداد"),
                  textFieldWidget(
                      label: "فی کارٹن تعداد",
                      imgPath: "assets/icons/corton_count.png",
                      inputType: TextInputType.number,
                      isReadOnly: true,
                      controller: saleController.perCartonCount),
                  textFieldWidget(
                      label: "جمله تعداد",
                      imgPath: "assets/icons/total.png",
                      inputType: TextInputType.number,
                      isReadOnly: true,
                      controller: saleController.totalCount),
                  textFieldWidget(
                      label: "قیمت",
                      imgPath: "assets/icons/price.png",
                      inputType: TextInputType.number,
                      controller: saleController.price,
                      prefixText: calculateTotal(),),
                      textFieldWidget(
                      label: "وصول",
                      imgPath: "assets/icons/income.png",
                      inputType: TextInputType.number,
                      controller: saleController.receivedPrice,onChange: (Value){
                        received=int.parse(Value);
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: CustomButton(
                      onPressed: () async {
                        received=int.parse(saleController.receivedPrice.text);
                        creditController.credits.text =
                            saleController.totalPrice.text;
                            creditController.received.text =
                            saleController.receivedPrice.text;
                        creditController.date.text = saleController.date.text;
                        goodsController.getGoods();
                        var goods = await goodsController
                            .getGoodsByName(saleController.name);
                            purchasePrice = goods!.purchasePrice!;
                            savingsController.addSavings(customerName: saleController.customerName, billNo: int.parse(saleController.bill.text), savings: savings, goodsName: saleController.name, totalCount: int.parse(saleController.totalCount.text), perPrice: int.parse(saleController.price.text), totalPrice: int.parse(saleController.totalPrice.text));
                        goodsController.updateGoodsCount(
                            goods.id.toString(),-int.parse(saleController.cartonCount.text));
                        creditController.addCreditEntry();

                        saleController.addSale();
                      },
                    ),
                  )
                ],
              ),
            ),
            
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              child: SellContainerWidget(
                isBaqaya: false,
                bill: totalBill,
                cortonCount: totalCarton,
                remaining: totalBill!-received,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              child: SellContainerWidget(
                isBaqaya: true,
                bill: totalBill!-received,
                cortonCount: creditController.calculateNetAmountById(customerId),
                remaining: (totalBill!+creditController.calculateNetAmountById(customerId))-received,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            Obx(() {
              saleController.filterSales(_searchController.text);
              return SizedBox(
                  height: saleController.filteredSaleList.length * 50 + 60,
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
                            DataColumn(label: SizedBox.shrink())
                        ],
                        rows: [
                          for (var row = 0;
                              row < saleController.filteredSaleList.length;
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
                                    saleController.filteredSaleList[row].totalPrice
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    saleController.filteredSaleList[row].price
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                 DataCell(
                                  Text(
                                    saleController.filteredSaleList[row].totalCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    saleController.filteredSaleList[row].perCartonCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    saleController.filteredSaleList[row].cartonCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    saleController.filteredSaleList[row].pieceCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    saleController.filteredSaleList[row].name
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
                                            final pdfFile = await SaleInvoicePdf.generate(sale: saleController.filteredSaleList[row]);
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
                          label: "search", imgPath: "", isSearch: true,controller: _searchController,onChange: (value)=>saleController.filterSales(value))),
                  Spacer(),
                  Text(
                    "1-3 of 6 Columns",
                    style: primaryTextStyle(color: whiteColor, size: 12),
                  )
                ],
              ),
            ),
            // TableWidget(tableRows: tableRows, tableColumns: tableColumns),
          ],
        ),
      ),
    );
  }
   String calculateTotal() {
    try {
      int price = int.parse(saleController.price.text ?? '0');
      int totalCount = int.parse(saleController.totalCount.text ?? '0');
      int total = price * totalCount;
      setState(() {
        saleController.totalPrice.text=total.toString();
      savings=total-purchasePrice*totalCount;
      print(">>>>>>>>>>>>>>>>>>>>SAVINGS: $savings");
      });
      return "$total :ٹوٹل";
    } catch (e) {
      // Handle the case where parsing fails
      print("Error: Invalid input. Please enter valid numbers.");
      return "ٹوٹل";
    }
  }
}
