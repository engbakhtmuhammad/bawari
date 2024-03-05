import 'package:bawari/controller/goods_controller.dart';
import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:bawari/view/widgets/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';

class GoodsScreen extends StatefulWidget {
  const GoodsScreen({super.key});

  @override
  State<GoodsScreen> createState() => _GoodsScreenState();
}

class _GoodsScreenState extends State<GoodsScreen> {
  GoodsController goodsController = Get.put(GoodsController());
  String? selectedValue;
  // Example data, you can replace it with your dynamic data
  List<String> tableColumns = [
    "سامان کا نام",
    "سامان کا نمبر",
    "کارٹن تعداد",
    "قیمت خرید",
    "قیمت فروخت",
    "isActive",
    "lineItem",
    // "پیس تعداد",
    // "کارتن تعداد",
    // "في كارتن تعداد",
    // "مکمل تعداد",
    // "في تعدادقيمت",
  ];
  List<List<String>> tableRows = [
    ["باوری لمیت (1 لیتر)", "5", "5", "12", "112", "12453"],
    ["باوری لمیت (1 لیتر)", "5", "5", "12", "112", "12453"],
  ];
  bool isActive=false;
  bool lineItem=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title: "سامان",),
      drawer: drawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            backContainerWidget(
                child: Column(
              children: [
                textFieldWidget(
                    label: "سامان کا نمبر",
                    imgPath: "assets/icons/number.png",
                    controller: goodsController.goodsNo),
                textFieldWidget(
                    label: "سامان کا نام",
                    imgPath: "assets/icons/name.png",
                    controller: goodsController.name),
                textFieldWidget(
                    label: "کارٹن تعداد",
                    imgPath: "assets/icons/cortons.png",
                    controller: goodsController.cartonCount),
                textFieldWidget(
                    label: "قیمت خرید",
                    imgPath: "assets/icons/price.png",
                    controller: goodsController.purchasePrice),
                textFieldWidget(
                    label: "قیمت فروخت",
                    imgPath: "assets/icons/income.png",
                    controller: goodsController.salePrice),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset("assets/icons/active.png"),
                    const SizedBox(width: 10),
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
                          isActive = value??false;
                          goodsController.isActive = value??false;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset("assets/icons/line.png"),
                    const SizedBox(width: 10),
                    Text(
                      'Line Item',
                      style: primaryTextStyle(),
                    ),
                    const SizedBox(width: 8),
                    Checkbox(
                      value: lineItem,
                      tristate: true,
                      onChanged: (value) {
                        setState(() {
                          lineItem = value??false;
                          goodsController.lineItem = value??false;
                        });
                      },
                    ),
                  ],
                ),
                CustomButton(
                  onPressed: () {
                    goodsController.addGoods();
                  },
                  icon: "assets/icons/file_sync.png",
                )
              ],
            )),
            // TableWidget(tableRows: tableRows, tableColumns: tableColumns),
            Obx(() {
              goodsController.getGoods();
              return SizedBox(
                  height: goodsController.goodsList.length * 50 + 60,
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
                              row < goodsController.goodsList.length;
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
                                    goodsController.goodsList[row].lineItem
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    goodsController.goodsList[row].isActive
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //7
                                DataCell(
                                  Text(
                                    goodsController.goodsList[row].salePrice
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //6
                                DataCell(
                                  Text(
                                    goodsController.goodsList[row].purchasePrice
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //5
                                DataCell(
                                  Text(
                                    goodsController.goodsList[row].cartonCount
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //4
                                DataCell(
                                  Text(
                                    goodsController.goodsList[row].goodsNo
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(size: 14),
                                  ),
                                ),
                                //3
                                DataCell(
                                  Text(
                                    goodsController.goodsList[row].name
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
                                      padding:
                                          EdgeInsets.only(left: defaultPadding),
                                      child:
                                          Image.asset("assets/icons/trash.png"),
                                    ),
                                    onTap: () {
                                      // Add your delete logic here using goodsController
                                      goodsController.deleteGoods(
                                          goodsController.goodsList[row].id
                                              .toString());
                                    },
                                  )),
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
