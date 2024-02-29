import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../widgets/custom_btn.dart';
import '../widgets/sell_container.dart';

class SellScreen extends StatelessWidget {
  const SellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example data, you can replace it with your dynamic data
  List<List<String>> tableData = [
    ['A1', 'B1', 'C1', 'D1', 'E1', 'F1'],
    ['A2', 'B2', 'C2', 'D2', 'E2', 'F2'],
    // Add more rows as needed
  ];
    return Scaffold(
      appBar: appBarWidget(title: "سامان فروخت"),
      drawer: drawerWidget(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            billAndDateWidget(),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(defaultHorizontalPadding),
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(defaultRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: defaultSpreadRadius,
                    blurRadius: defaultBlurRadius,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
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
          SizedBox(
  height: 130,
  width: double.infinity,
  child: ListView(
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.all(5.0),
    children: <Widget>[
      DataTable(
                columns: [
                  for (var i = 0; i < 6; i++)
                    DataColumn(
                      label: Text('Column $i'),
                    ),
                ],
                rows: [
                  for (var row in tableData)
                    DataRow(
                      cells: [
                        for (var cell in row)
                          DataCell(
                            Text(cell),
                          ),
                      ],
                    ),
                ],
              ),
      
    ],
  ),
),


            const SellContainerWidget(btnTitle: "نقد وصولي",bill: 400,cortonCount: 2,remaining: 3,)
          ],
        ),
      ),
    );
  }
}

// Create a separate widget for table cells to make the code cleaner
class TableCellWidget extends StatelessWidget {
  final String data;

  TableCellWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Text(data),
    );
  }
}