import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:bawari/view/widgets/custom_btn.dart';
import 'package:bawari/view/widgets/table_widget.dart';
import 'package:flutter/material.dart';

class GoodsScreen extends StatefulWidget {
  const GoodsScreen({super.key});

  @override
  State<GoodsScreen> createState() => _GoodsScreenState();
}

class _GoodsScreenState extends State<GoodsScreen> {
   String? selectedValue;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: appBarWidget(title: "سامان", context: context),
      drawer: drawerWidget(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            backContainerWidget(
                child: Column(
              children: [
                textFieldWidget(
                    label: "سامان کا نمبر", imgPath: "assets/icons/number.png"),
                textFieldWidget(
                    label: "سامان کا نام", imgPath: "assets/icons/name.png"),
                
                textFieldWidget(
                    label: "کارٹن تعداد", imgPath: "assets/icons/cortons.png"),
                    textFieldWidget(
                    label: "قیمت خرید", imgPath: "assets/icons/price.png"),
                    textFieldWidget(
                    label: "قیمت فروخت", imgPath: "assets/icons/income.png"),
                    RadioListTile<String>(
            title:Row(
              children: [
                
                Text('is Active',style: primaryTextStyle(),),
                const SizedBox(width: 8),
                Image.asset("assets/icons/active.png")
              ],
            ),
            value: 'option1',
            groupValue: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
            },
          ),
          RadioListTile<String>(
            title: Row(
              children: [
                Text('Line Item',style: primaryTextStyle(),),
                const SizedBox(width: 8),
                Image.asset("assets/icons/line.png")
              ],
            ),
            value: 'option2',
            groupValue: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
            },
          ),
          CustomButton(onPressed: (){},icon: "assets/icons/file_sync.png",)
              ],
            )),
            TableWidget(tableRows: tableRows, tableColumns: tableColumns),
            
            
          ],
        ),
      ),
    );
  }
}
