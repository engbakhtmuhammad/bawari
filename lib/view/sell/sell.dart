import 'package:bawari/controller/sale_controller.dart';
import 'package:bawari/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bawari/utils/text_styles.dart';
import '../widgets/custom_btn.dart';
import '../widgets/sell_container.dart';
import '../widgets/table_widget.dart';
import 'package:get/get.dart';
import 'package:bawari/utils/colors.dart';
import '../../utils/constants.dart';




class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  DateTime selectedDate = DateTime.now();
  TextEditingController? billController;
  TextEditingController? dateController;
  SaleController saleController = Get.put(SaleController());

// Example data, you can replace it with your dynamic data
  List<String> tableColumns = [
    "سامان",
    "پیس تعداد",
    "کارتن تعداد",
    "في كارتن تعداد",
    "مکمل تعداد",
    "في تعدادقيمت",
    "مکمل تعداد",
    "مکمل تعداد",
    "مکمل تعداد",
    "في تعدادقيمت",
    "في تعدادقيمت",

  ];
  // List<List<String>> tableRows = [
  //   ["باوری لمیت (1 لیتر)", "5", "5", "12", "112", "12453"],
  //   ["باوری لمیت (1 لیتر)", "5", "5", "12", "112", "12453"],
  // ];
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController!.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }
  @override
  void initState() {
    dateController=TextEditingController(text: DateFormat('dd/MM/yyyy').format(selectedDate));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      appBar: appBarWidget(title: "سامان فروخت",context: context),
      drawer: drawerWidget(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            billAndDateWidget(dateController: dateController,onPressed2: () => _selectDate(context),),
            backContainerWidget(
              child: Column(
                children: [
                  textFieldWidget(
                      label: "نام",
                      imgPath: "assets/icons/name.png",
                      controller: saleController.name,),

                  textFieldWidget(
                      label: "نوٹ",
                      imgPath: "assets/icons/note.png",
                      maxLine: 4,
                      controller: saleController.note),
                  textFieldWidget(
                      label: "سامان نمبر",
                      imgPath: "assets/icons/number.png",
                      inputType: TextInputType.number,
                      controller: saleController.goodsNo),
                  textFieldWidget(
                      label: "پیس تعداد",
                      imgPath: "assets/icons/count.png",
                      inputType: TextInputType.number,
                      controller: saleController.pieceCount),
                  textFieldWidget(
                      label: "کارٹن تعداد",
                      imgPath: "assets/icons/cortons.png",
                      inputType: TextInputType.number,
                      controller: saleController.cartonCount),
                  textFieldWidget(
                      label: "فی کارٹن تعداد",
                      imgPath: "assets/icons/corton_count.png",
                      inputType: TextInputType.number,
                      controller: saleController.perCartonCount),
                  textFieldWidget(
                      label: "جمله تعداد",
                      imgPath: "assets/icons/total.png",
                      inputType: TextInputType.number,
                      controller: saleController.totalCount),
                  textFieldWidget(
                      label: "قیمت",
                      imgPath: "assets/icons/price.png",
                      inputType: TextInputType.number,
                      controller: saleController.price),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: CustomButton(
                      onPressed: () {
                        saleController.addSale();
                      },
                    ),
                  )
                ],
              ),
            ),

            Obx(() {
              saleController.getSale();
              return SizedBox(
                  height: saleController.saleList.length * 50 + 60,
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

                        ],
                        rows: [
                          for (var row = 0;
                          row < saleController.saleList.length;
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
                                    saleController.saleList[row].date
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    saleController.saleList[row].date
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),

                                //7
                                DataCell(
                                  Text(
                                    saleController
                                        .saleList[row].totalCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //6
                                DataCell(
                                  Text(
                                    saleController.saleList[row].price
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //5
                                DataCell(
                                  Text(
                                    saleController
                                        .saleList[row].perCartonCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //4
                                DataCell(
                                  Text(
                                    saleController
                                        .saleList[row].cartonCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //3
                                DataCell(
                                  Text(
                                    saleController.saleList[row].note
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),

                                //2
                                DataCell(
                                  Text(
                                    saleController.saleList[row].billNo
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //1
                                DataCell(
                                  Text(
                                    saleController.saleList[row].name
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    saleController.saleList[row].name
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    saleController.saleList[row].name
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
            // TableWidget(tableRows: tableRows, tableColumns: tableColumns),
            const SizedBox(
              height: 20,
            ),
            // const SellContainerWidget(
            //   btnTitle: "نقد وصولي",
            //   bill: 400,
            //   cortonCount: 2,
            //   remaining: 3,
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            // const SellContainerWidget(
            //   btnTitle: "نقد وصولي",
            //   bill: 400,
            //   cortonCount: 2,
            //   remaining: 3,
            // )
            Container(
              height: 70,
              padding:
              EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              width: double.infinity,
              color: secondaryColor,
              child: Obx(
                    ()=> Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${saleController.getTotalPrice()}",
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
                          "${saleController.getTotalCartonCount()}",
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
            )
          ],
        ),
      ),
    );
  }
}

