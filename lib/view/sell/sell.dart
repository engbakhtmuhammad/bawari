
import 'package:bawari/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/custom_btn.dart';
import '../widgets/sell_container.dart';
import '../widgets/table_widget.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  DateTime selectedDate = DateTime.now();
  TextEditingController? billController;
  TextEditingController? dateController;

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

