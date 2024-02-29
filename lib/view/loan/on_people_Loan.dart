import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/constants.dart';
import 'package:bawari/view/widgets/custom_btn.dart';
import 'package:bawari/view/widgets/table_widget.dart';
import 'package:flutter/material.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({super.key});

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
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
      
      appBar: appBarWidget(title: "پہ خلکو باندے", context: context),
      drawer: drawerWidget(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableWidget(tableRows: tableRows, tableColumns: tableColumns),
            Padding(
              padding: EdgeInsets.all(defaultHorizontalPadding),
              child: CustomButton(onPressed: (){},icon: "assets/icons/file_sync.png",),
            )
            
          ],
        ),
      ),
    );
  }
}
