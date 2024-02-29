import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../widgets/custom_btn.dart';
import '../widgets/sell_container.dart';
import '../widgets/table_widget.dart';

class SellScreen extends StatelessWidget {
  const SellScreen({super.key});

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
      
      appBar: appBarWidget(title: "سامان فروخت",context: context),
      drawer: drawerWidget(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            billAndDateWidget(),
            backContainerWidget(
              child: Column(
                children: [
                  textFieldWidget(
                      label: "نام", imgPath: "assets/icons/name.png"),
                  textFieldWidget(
                      label: "نوٹ",
                      imgPath: "assets/icons/note.png",
                      maxLine: 4),
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
            const SizedBox(
              height: 20,
            ),
            const SellContainerWidget(
              btnTitle: "نقد وصولي",
              bill: 400,
              cortonCount: 2,
              remaining: 3,
            ),
            const SizedBox(
              height: 20,
            ),
            const SellContainerWidget(
              btnTitle: "نقد وصولي",
              bill: 400,
              cortonCount: 2,
              remaining: 3,
            )
          ],
        ),
      ),
    );
  }
}

