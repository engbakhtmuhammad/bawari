import 'package:bawari/controller/customer_controller.dart';
import 'package:bawari/controller/sale_controller.dart';
import 'package:bawari/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:get/get.dart';
import 'package:bawari/utils/colors.dart';
import '../../model/sale_model.dart';
import '../../utils/constants.dart';
import '../invoice/file_handle_api.dart';
import '../invoice/sale_invoice.dart';

class OldSaleInfoScreen extends StatefulWidget {
  const OldSaleInfoScreen({super.key});

  @override
  State<OldSaleInfoScreen> createState() => _SaleInfoScreenState();
}

class _SaleInfoScreenState extends State<OldSaleInfoScreen> {
  SaleController saleController = Get.put(SaleController());
  CustomerController customerController = Get.put(CustomerController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<DropdownMenuItem<String>> customerDropDownList = [];
  List<SaleModel> selectedSales = [];

// Inside a method where you fetch customers, such as in the initState method
  void fetchCustomers() async {
    List<String?> customerName = await customerController.getCustomerNames();
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

// Example data, you can replace it with your dynamic data
  List<String> tableColumns = [
    'بل نمبر',
    "سامان",
    "کارتن تعداد",
    "في كارتن تعداد",
    "جمله تعداد",
    "في تعدادقيمت",
    "مکمل تعدادقيمت",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    fetchCustomers();
    return Scaffold(
      key: scaffoldKey,
      appBar: appBarWidget(
        title: "سامان فروخت معلومات",
        openDrawer: () => scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: drawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            customerAndDateWidget(
              endDateController: saleController.endDate,
              onEndDatePressed: (){
                selectDate(saleController.endDate);selectedSales.clear();
              },
              startDateController: saleController.startDate,
              onStartDatePressed: () {
                selectDate(saleController.startDate);selectedSales.clear();
              },
              label: "گراک نوم غوره کړئ",
              dropDownList: customerDropDownList,
              onChanged: (value) async {
                setState(() {
                  saleController.searchOldController.text=value;
                  selectedSales.clear();
                });
              },
            ),
            SizedBox(
              height: defaultPadding,
            ),
            Obx(() {
              saleController.filterOldSales();
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
                        onSelectAll: (isSelectedAll) {
                        setState(() => selectedSales = isSelectedAll!
                            ? saleController.filteredSaleList
                            : []);
                      },
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => secondaryColor.withOpacity(.5)),
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
                            DataColumn(
                            numeric: true,
                            label: GestureDetector(
                              onTap: () async {
                                final pdfFile = await SaleInvoicePdf.generate(
                                      sale: saleController.filteredSaleList);
                                  FileHandleApi.openFile(pdfFile);
                              },
                              child: Text(
                                "پرنٹ",
                                textAlign: TextAlign.center,
                                style: boldTextStyle(color: whiteColor),
                              ),
                            ),
                          ),
                        ],
                        rows: [
                          for (var row = 0;
                              row < saleController.filteredSaleList.length;
                              row++)
                            DataRow(
                              selected: selectedSales
                                .contains(saleController.filteredSaleList[row]),
                            onSelectChanged: (isSelected) => setState(() {
                              final isAdding = isSelected != null && isSelected;

                              isAdding
                                  ? selectedSales
                                      .add(saleController.filteredSaleList[row])
                                  : selectedSales.remove(
                                      saleController.filteredSaleList[row]);
                            }),
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
                                    "${int.parse(saleController.filteredSaleList[row].price.toString()) * int.parse(saleController.filteredSaleList[row].totalCount.toString())}",
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
                                    saleController
                                        .filteredSaleList[row].totalCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    saleController
                                        .filteredSaleList[row].perCartonCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    saleController
                                        .filteredSaleList[row].cartonCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    saleController
                                        .filteredSaleList[row].name
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    saleController.filteredSaleList[row].billNo
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
                                              "assets/icons/print.png",
                                              height: defaultIconsSize,
                                            ),
                                          ),
                                          onTap: () async {
                                            final pdfFile =
                                                await SaleInvoicePdf.generate(
                                                    sale: [
                                                  saleController
                                                      .filteredSaleList[row]
                                                ]);
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
                          controller: saleController.searchOldController,
                          label: "search",
                          imgPath: "",
                          isSearch: true)),
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
      floatingActionButton: selectedSales.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: primaryColor,
              child: Image.asset(
                "assets/icons/print.png",
                color: whiteColor,
                height: defaultIconsSize,
              ),
              onPressed: () async {
                final pdfFile =
                    await SaleInvoicePdf.generate(sale: selectedSales);
                // opening the pdf file
                FileHandleApi.openFile(pdfFile);
                // Get.to(InvoiceScreen());
              },
            )
          : SizedBox(),
    );
  }
}
