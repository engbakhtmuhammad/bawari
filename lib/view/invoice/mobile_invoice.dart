import 'dart:async';
import 'dart:typed_data';

import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/constants.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';

class InvoiceScreen extends StatefulWidget {
  var tableColumns;
  var tableData;
  InvoiceScreen({super.key, this.tableColumns, this.tableData});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  late Uint8List _imageFile;
  List<String> tableColumns = [
    "سامان",
    "پیس تعداد",
    "کارتن تعداد",
    // "في كارتن تعداد",
    "جمله تعداد",
    // "في تعدادقيمت",
    "مکمل تعدادقيمت",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title: "بل تفصیل"),
      body: Column(
        children: [
          backContainerWidget(
              child: Screenshot(
            controller: screenshotController,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  "assets/images/logo.png",
                  width: Get.size.width * .25,
                ),
                Text(
                  "حاجی صالح محمد",
                  style: boldTextStyle(),
                ),
                Text(
                  formatDateTime(DateTime.now()),
                  style: primaryTextStyle(color: greyColor, size: 12),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text(
                    "78",
                    style: boldTextStyle(),
                  ),
                  trailing: Text(
                    "ٹوٹل قیمت",
                    style: boldTextStyle(),
                  ),
                ),
                for (int i = 0; i < tableColumns.length; i++)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: defaultHorizontalPadding),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("84"),
                            Text(tableColumns[i]),
                          ],
                        ),
                        i == tableColumns.length - 1
                            ? SizedBox()
                            : Divider(
                                color: greyColor.withOpacity(.2),
                              )
                      ],
                    ),
                  ),
                Divider(),
                SizedBox(
                  height: defaultPadding,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultHorizontalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("84"), Text("زوڑ حساب")],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultHorizontalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("84"), Text("جمله بقايا")],
                  ),
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Row(
                  children: List.generate(
                      150 ~/ 3,
                      (index) => Expanded(
                            child: Container(
                              color: index % 2 == 0
                                  ? Colors.transparent
                                  : primaryColor,
                              height: 2,
                            ),
                          )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: defaultHorizontalPadding),
                  child: Column(
                    children: [
                      Text("Salih اکاونٹ نمبر عزیزی بانک"),
                      Text("008301201346923",
                          style:
                              boldTextStyle(size: 13, color: secondaryColor)),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      Image.asset("assets/images/bottom.png"),
                    ],
                  ),
                ),
              ],
            ),
          )),
          ElevatedButton(
            onPressed: () async {
              // Capture the widget as an image
              screenshotController
                  .capture()
                  .then((Uint8List image) {
                    //Capture Done
                    setState(() {
                      _imageFile = image;
                    });
                  } as FutureOr Function(Uint8List? value))
                  .catchError((onError) {
                print(onError);
              });
            },
            child: Text('Capture and Share'),
          ),
        ],
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    // Format the date part (e.g., "10 Dec, 2024")
    String formattedDate = DateFormat('dd MMM, yyyy').format(dateTime);

    // Format the time part (e.g., "09:30 PM")
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    // Combine the formatted date and time with a separator (|)
    return '$formattedDate | $formattedTime';
  }
}
