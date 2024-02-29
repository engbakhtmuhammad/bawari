import 'dart:math';

import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:bawari/view/widgets/table_widget.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../widgets/custom_btn.dart';

class CreditScreen extends StatelessWidget {
  const CreditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example data, you can replace it with your dynamic data
    List<String> tableColumns = [
      "سامان",
      "پیس تعداد",
      "کارتن تعداد",
      "في كارتن تعداد",
      "مکمل تعداد",
      "في تعدادقيمت",
    ];
    List<List<String>> tableRows = [
      ["باوری لمیت (1 لیتر)", "5", "5", "12", "112", "12453"],
      ["باوری لمیت (1 لیتر)", "5", "5", "12", "112", "12453"],
    ];
    var dropDownList = const [
      DropdownMenuItem(
        alignment: Alignment.centerLeft,
        value: "جیلانی لشکرگاه",
        child: Text("جیلانی لشکرگاه"),
      ),
      DropdownMenuItem(
        alignment: Alignment.centerLeft,
        value: "City 2",
        child: Text("City 2"),
      ),
    ];
    return Scaffold(
      
      appBar: appBarWidget(title: "وصولی", context: context),
      drawer: drawerWidget(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            backContainerWidget(
                child: Column(
              children: [
                textFieldWidget(
                    label: "تمبر", imgPath: "assets/icons/invoice.png"),
                textFieldWidget(
                    label: "تاریخ", imgPath: "assets/icons/calendar.png"),
                dropDownTextFieldWidget(
                    label: "گراک نوم غوره کړئ",
                    imgPath: "assets/icons/id.png",
                    dropDownList: dropDownList),
                textFieldWidget(
                    label: "حوالا ادرس", imgPath: "assets/icons/price.png"),
              ],
            )),
            TableWidget(tableRows: tableRows, tableColumns: tableColumns),
            const SizedBox(
              height: 20,
            ),
            backContainerWidget(
                child: Column(
              children: [
                Container(
                    height: 50,
                    width: double.infinity,
                    color: secondaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "data",
                                style: boldTextStyle(color: whiteColor),
                              ),
                              Text(
                                "data",
                                style: boldTextStyle(color: whiteColor),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: defaultIconsSize,
                        )
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(top: defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width * .3,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(defaultRadius),
                                  border: Border.all(color: greyColor)),
                              child: Center(child: Text("Bill")),
                            ),
                            Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width * .3,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(defaultRadius),
                                  border: Border.all(color: greyColor)),
                              child: Center(child: Text("Bill")),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        child: Image.asset(
                          "assets/icons/trash.png",
                          width: defaultIconsSize,
                          height: defaultIconsSize,
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
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
                        onPressed: () {},
                        icon: "assets/icons/file_sync.png",
                      ),
                    ),
                    Text(
                      "Total: 500",
                      style: boldTextStyle(),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                CustomButton(onPressed: (){},label: "سابقہ بل وصولی",)
              ],
            ))
          ],
        ),
      ),
    );
  }
}
