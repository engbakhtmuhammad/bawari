import 'package:bawari/utils/common.dart';
import 'package:bawari/view/widgets/table_widget.dart';
import 'package:flutter/material.dart';

class LoanInfoScreen extends StatefulWidget {
  const LoanInfoScreen({super.key});

  @override
  State<LoanInfoScreen> createState() => _LoanInfoScreenState();
}

class _LoanInfoScreenState extends State<LoanInfoScreen> {
   String? selectedValue;
   // Example data, you can replace it with your dynamic data
    List<String> tableColumns = [
      "گیراک نمبر",
      "گیراک نام",
      "بقیہ پیسے",
    ];
    List<List<String>> tableRows = [
      ["1","محمد صادق لشکرگاه","12453"],
      ["2","با خان لشکرقا","12453"],
      ["3","عبد الغفار كرئش","12453"],
      ["4","حاجی محمد جان","12453"],
      ["5","جیلانی لشکرگاه","12453"],
    ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: appBarWidget(title: "پور معلومات",),
      drawer: drawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            billAndDateWidget(title: "ابتدائی",imgPath: "assets/icons/calendar.png",title2: "اختتامي",imgPath2: "assets/icons/calendar.png"),
            TableWidget(tableRows: tableRows, tableColumns: tableColumns),
            
            
          ],
        ),
      ),
    );
  }
}
