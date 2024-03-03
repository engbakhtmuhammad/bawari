import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/common.dart';
import '../../utils/constants.dart';
import '../../utils/text_styles.dart';

class TableWidget extends StatelessWidget {
  const TableWidget({
    super.key,
    required this.tableRows,
    required this.tableColumns,
  });

  final List<List<String>> tableRows;
  final List<String> tableColumns;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: tableRows.length*50+60,
          width: double.infinity,
          child: ListView(
            shrinkWrap: true,
            reverse: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(5.0),
            children: <Widget>[
              DataTable(
                headingRowColor:
                    MaterialStateColor.resolveWith((states) => greyColor),
                columnSpacing: 10.0, // Adjust the space between columns
                columns: [
                  for (var i = tableColumns.length; i > 0; i--)
                    DataColumn(
                      numeric: true,
                      label: Text(
                        "${tableColumns[i - 1]}   ",
                        textAlign: TextAlign.center,
                        style: boldTextStyle(color: whiteColor),
                      ),
                    ),
                ],
                rows: [
                  for (var row in tableRows)
                    DataRow(
                      color: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          // Set the background color of the rows
                          if (states.contains(MaterialState.selected)) {
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.08);
                          }
                          return Colors.transparent;
                        },
                      ),
                      cells: [
                        for (var i = row.length; i > 0; i--)
                          DataCell(
                            Text(
                              "${row[i - 1]}  ",
                              textAlign: TextAlign.center,
                              style: primaryTextStyle(size: 14),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
        Container(
              padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              width: double.infinity,
              height: 50,
              color: secondaryColor,
              child: Row(
                children: [
                  Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(defaultRadius),
                      ),
                      child: textFieldWidget(
                          label: "search", imgPath: "", isSearch: true)),
                          Spacer(),
                          Text("1-3 of 6 Columns",style: primaryTextStyle(color: whiteColor,size: 12),)
                ],
              ),
            ),
      ],
    );
  }
}
