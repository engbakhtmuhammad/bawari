import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:bawari/view/widgets/custom_btn.dart';
import 'package:bawari/view/widgets/table_widget.dart';
import 'package:flutter/material.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
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
      
      appBar: appBarWidget(title: "کسٹمر", context: context),
      drawer: drawerWidget(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            backContainerWidget(
                child: Column(
              children: [
                textFieldWidget(
                    label: "کسٹمر کا نمبر", imgPath: "assets/icons/note.png"),
                textFieldWidget(
                    label: "کسٹمر کا نام", imgPath: "assets/icons/id.png"),
                
                textFieldWidget(
                    label: "کسٹمر کا پتہ", imgPath: "assets/icons/address.png"),
                    textFieldWidget(
                    label: "کسٹمر کا فون", imgPath: "assets/icons/phone.png"),
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
