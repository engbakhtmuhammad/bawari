import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/constants.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:flutter/material.dart';

class InvoiceScreen extends StatefulWidget {
  String? customerName;
  String? customerPhone;
  String? date;
  String? billNo;
  var titleList;
  var dataList;
  InvoiceScreen({Key? key, this.billNo, this.customerName, this.customerPhone,this.date,this.titleList,this.dataList});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final double containerWidth = 2480.0;
  final double containerHeight = 1748.0;
  List<String> tableColumns = [
    "گیراک نمبر",
    "گیراک نام",
    "بقیہ پیسے",
  ];
  List<List<String>> tableRows = [
    ["1", "محمد صادق لشکرگاه", "12453"],
    ["2", "با خان لشکرقا", "12453"],
    ["3", "عبد الغفار كرئش", "12453"],
    ["4", "حاجی محمد جان", "12453"],
    ["5", "جیلانی لشکرگاه", "12453"],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Container(
            width: 360,
            height: 480,
            padding: EdgeInsets.only(top: 100),
            decoration: BoxDecoration(
              color: billBack,
                image: DecorationImage(
                    image: AssetImage("assets/images/bawri_back.png"),
                    fit: BoxFit.fitWidth)),
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: widget.billNo??"___________",
                          style:
                              TextStyle(fontSize: 7.0, color: blackColor,fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: ' بل نمبر',
                              style: TextStyle(
                                fontSize: 7.0,
                                color: blackColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: widget.date??"___________",
                          style:
                              TextStyle(fontSize: 7.0, color: blackColor,fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: 'تاریخ',
                              style: TextStyle(
                                fontSize: 7.0,
                                color: blackColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),Text.rich(
                        TextSpan(
                          text: widget.customerPhone??"___________",
                          style:
                              TextStyle(fontSize: 7.0, color: blackColor,fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: 'موبائل شماره',
                              style: TextStyle(
                                fontSize: 7.0,
                                color: blackColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),Text.rich(
                        TextSpan(
                          text: widget.customerName??"___________",
                          style:
                              TextStyle(fontSize: 7.0, color: blackColor,fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: 'نوم',
                              style: TextStyle(
                                fontSize: 7.0,
                                color: blackColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6,),
                  Row(
                    children: [
                      titleContainer(
                          title: "Total Price",
                          color: Color(0xff87292A),
                          width: 63),
                      titleContainer(
                          title: "Guess", color: Color(0xff87292A), width: 28),
                      titleContainer(
                          title: "Guess", color: Color(0xff87292A), width: 28),
                      titleContainer(
                          title: "Guess", color: Color(0xff87292A), width: 28),
                      titleContainer(
                          title: "Guess", color: Color(0xff87292A), width: 28),
                      titleContainer(
                          title: "Guess", color: Color(0xff87292A), width: 28),
                      Expanded(
                        child: titleContainer(
                            title: "Guess", color: Color(0xff87292A), width: 100),
                      ),
                      titleContainer(
                          title: "No", color: Color(0xff87292A), width: 15),
                    ],
                  ),
                  Row(
                    children: [
                      titleContainer(
                          title: "Total Price",
                          color: secondaryColor,
                          width: 63),
                      titleContainer(
                          title: "Guess", color: secondaryColor, width: 28),
                      titleContainer(
                          title: "Guess", color: secondaryColor, width: 28),
                      titleContainer(
                          title: "Guess", color: secondaryColor, width: 28),
                      titleContainer(
                          title: "Guess", color: secondaryColor, width: 28),
                      titleContainer(
                          title: "Guess", color: secondaryColor, width: 28),
                      Expanded(
                        child: titleContainer(
                            title: "Guess", color: secondaryColor, width: 100),
                      ),
                      titleContainer(
                          title: "No", color: secondaryColor, width: 15),
                    ],
                  ),
                  for (int i = 0; i < 9; i++)
                    Row(
                      children: [
                        dataContainer(data: "", width: 63),
                        dataContainer(data: "", width: 28),
                        dataContainer(data: "", width: 28),
                        dataContainer(data: "", width: 28),
                        dataContainer(data: "", width: 28),
                        dataContainer(data: "", width: 28),
                        Expanded(child: dataContainer(data: "", width: 100)),
                        dataContainer(data: "${i + 1}", width: 15),
                      ],
                    ),
                  // SizedBox(
                  //   height: tableRows.length * 50 + 60,
                  //   width: double.infinity,
                  //   child: ListView(
                  //     shrinkWrap: true,
                  //     reverse: true,
                  //     scrollDirection: Axis.horizontal,
                  //     padding: const EdgeInsets.all(5.0),
                  //     children: <Widget>[
                  //       DataTable(
                  //         headingRowColor: MaterialStateColor.resolveWith(
                  //             (states) => greyColor),
                  //         columnSpacing: 5.0, // Adjust the space between columns
                  //         columns: [
                  //           for (var i = tableColumns.length; i > 0; i--)
                  //             DataColumn(
                  //               numeric: true,
                  //               label: Text(
                  //                 "${tableColumns[i - 1]}   ",
                  //                 textAlign: TextAlign.center,
                  //                 style:
                  //                     boldTextStyle(color: whiteColor, size: 12),
                  //               ),
                  //             ),
                  //         ],
                  //         rows: [
                  //           for (var row in tableRows)
                  //             DataRow(
                  //               color: MaterialStateProperty.resolveWith<Color>(
                  //                 (Set<MaterialState> states) {
                  //                   // Set the background color of the rows
                  //                   if (states.contains(MaterialState.selected)) {
                  //                     return Theme.of(context)
                  //                         .colorScheme
                  //                         .primary
                  //                         .withOpacity(0.08);
                  //                   }
                  //                   return Colors.transparent;
                  //                 },
                  //               ),
                  //               cells: [
                  //                 for (var i = row.length; i > 0; i--)
                  //                   DataCell(
                  //                     Text(
                  //                       "${row[i - 1]}  ",
                  //                       textAlign: TextAlign.center,
                  //                       style: primaryTextStyle(size: 10),
                  //                     ),
                  //                   ),
                  //               ],
                  //             ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container titleContainer(
      {required String title,
      required Color color,
      double? width,
      double? height}) {
    return Container(
      margin: EdgeInsets.all(1),
      height: height ?? 20,
      width: width ?? 50,
      decoration: BoxDecoration(color: color),
      child: Center(
          child: Text(
        title,
        style: boldTextStyle(size: 10, color: whiteColor),
        textAlign: TextAlign.center,
      )),
    );
  }

  Container dataContainer(
      {required String data, double? width, double? height}) {
    return Container(
      margin: EdgeInsets.all(1),
      height: height ?? 20,
      width: width ?? 50,
      decoration: BoxDecoration(border: Border.all()),
      child: Center(
          child: Text(
        data,
        style: primaryTextStyle(size: 10, color: blackColor),
        textAlign: TextAlign.center,
      )),
    );
  }
}
