import 'dart:math';

import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:bawari/view/widgets/table_widget.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../widgets/custom_btn.dart';

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({super.key});

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
    return Scaffold(
      
      appBar: appBarWidget(title: "سامان خرید", context: context),
      drawer: drawerWidget(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            billAndDateWidget(),
            backContainerWidget(
              child: Column(
                children: [
                  textFieldWidget(label: "نام", imgPath: "assets/icons/name.png"),
                  textFieldWidget(label: "نوٹ", imgPath: "assets/icons/note.png",maxLine: 4),
                  textFieldWidget(
                      label: "سامان نمبر", imgPath: "assets/icons/number.png"),
                  textFieldWidget(
                      label: "جمله تعداد", imgPath: "assets/icons/total.png"),
                  textFieldWidget(
                      label: "قیمت", imgPath: "assets/icons/price.png"),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: CustomButton(
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ),
            TableWidget(tableRows: tableRows, tableColumns: tableColumns),
            SizedBox(height: 20,),
            Container(
              height: 70,
              padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              width: double.infinity,
              color: secondaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("ٹوٹل بل",style: primaryTextStyle(color: whiteColor),),
                  Text("کارٹن تعداد",style: primaryTextStyle(color: whiteColor),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
