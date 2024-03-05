import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:bawari/view/dues/add_dues.dart';
import 'package:bawari/view/widgets/table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';
import '../widgets/custom_btn.dart';

class DueScreen extends StatelessWidget {
  const DueScreen({super.key});

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
      
      appBar: appBarWidget(title: "را باندی",),
      drawer: drawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            backContainerWidget(
                child: Column(
              children: [
                textFieldWidget(
                    label: "تاریخ", imgPath: "assets/icons/calendar.png"),
                dropDownTextFieldWidget(
                    label: "گراک نوم غوره کړئ",
                    imgPath: "assets/icons/id.png",
                    dropDownList: dropDownList),
                textFieldWidget(
                    label: "حوالا ادرس", imgPath: "assets/icons/price.png"),
                    textFieldWidget(label: "را باندی", imgPath: "assets/icons/dues.png"),
                textFieldWidget(label: "وصول", imgPath: "assets/icons/income.png"),
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
              ],
            )),
             Align(alignment: Alignment.centerRight, child: Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              child: Text("راناندی کهاته",style: boldTextStyle(),),
            )),
            TableWidget(tableRows: tableRows, tableColumns: tableColumns),
          ],
        ),
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: ()=>Get.to(AddDueScreen()),
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
