import 'package:bawari/utils/common.dart';
import 'package:bawari/view/widgets/table_widget.dart';
import 'package:flutter/material.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
   String? selectedValue;
   // Example data, you can replace it with your dynamic data
    List<String> tableColumns = [
      "سامان نمبر",
      "سامان",
      "پیس تعداد",
      "کارتن تعداد",
      "في كارتن تعداد",
      "مکمل تعداد",
      "في تعدادقيمت",
    ];
    List<List<String>> tableRows = [
      ["89","باوری لمیت (1 لیتر)", "5", "5", "12", "112", "12453"],
      ["56","باوری لمیت (1 لیتر)", "5", "5", "12", "112", "12453"],
      ["89","باوری لمیت (1 لیتر)", "5", "5", "12", "112", "12453"],
      ["56","باوری لمیت (1 لیتر)", "5", "5", "12", "112", "12453"],
    ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: appBarWidget(title: "گودام سٹاک", context: context),
      drawer: drawerWidget(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableWidget(tableRows: tableRows, tableColumns: tableColumns),
            
            
          ],
        ),
      ),
    );
  }
}
