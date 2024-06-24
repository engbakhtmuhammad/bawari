import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/credit_controller.dart';
import 'file_handle_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CashInvoicePdf {
  static Future<File> generate(
      {required List cash, required String name}) async {
    final pdf = pw.Document();
    CreditController creditController = Get.put(CreditController());
    double totalBaqaya = 0;
    double lastRecieved = 0;

    for (var cashItem in cash) {
      final baqaya = await creditController
          .getTotalDuesByName(cashItem.customerName.toString());
      totalBaqaya += baqaya;
    }
    lastRecieved+=cash.last.price;

    final topImage =
        (await rootBundle.load('assets/images/top.png')).buffer.asUint8List();
    final bottomImage = (await rootBundle.load('assets/images/address.png'))
        .buffer
        .asUint8List();
    // Load the font file for 'Noto Naskh Arabic'
    final fontData = await rootBundle.load('assets/fonts/Almarai-Regular.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    final tableHeadersUrdu = ["بل نمبر", 'بل تاریخ', 'پیسۓ وصول'];
    final tableData = [
      [
        cash.last.price.toString(),
        cash.last.date.toString(),
        cash.last.billNo.toString(),
      ]
    ];

    pdf.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsetsDirectional.all(20),
        textDirection: pw.TextDirection.rtl,
        build: (context) {
          return [
            pw.SizedBox(
              width: double.infinity,
              height: 120,
              child: pw.Image(pw.MemoryImage(topImage), fit: pw.BoxFit.fill),
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.SizedBox(height: 5 * PdfPageFormat.mm),
            pw.Directionality(
              textDirection: pw.TextDirection.ltr,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(children: [
                    pw.Text(
                      "     ${cash.last.address.toString()}     ",
                      style: pw.TextStyle(
                        font: ttf,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                    pw.SizedBox(height: 2),
                    pw.Container(width: 100, height: 1, color: PdfColors.black)
                  ]),
                  pw.Text(
                    "ادرس",
                    style:
                        pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.SizedBox(width: 10),
                  pw.Column(children: [
                    pw.Text(
                      "     ${DateFormat('dd-MM-yyyy').format(DateTime.now())}     ",
                      style: pw.TextStyle(
                        font: ttf,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                    pw.SizedBox(height: 2),
                    pw.Container(width: 100, height: 1, color: PdfColors.black)
                  ]),
                  pw.Text(
                    "تاریخ",
                    style:
                        pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.SizedBox(width: 10),
                  pw.Column(children: [
                    pw.Text(
                      "     ${cash.last.billNo.toString()}     ",
                      style: pw.TextStyle(
                        font: ttf,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                    pw.SizedBox(height: 2),
                    pw.Container(width: 100, height: 1, color: PdfColors.black)
                  ]),
                  pw.Text(
                    "بل نمبر",
                    style:
                        pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.SizedBox(width: 10)
                ],
              ),
            ),
            pw.SizedBox(
              height: 10,
            ),
            pw.Directionality(
              textDirection: pw.TextDirection.ltr,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.SizedBox(width: 10),
                  pw.Column(children: [
                    pw.Text(
                      "     ${name.toString()}     ",
                      style: pw.TextStyle(
                        font: ttf,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                    pw.SizedBox(height: 2),
                    pw.Container(width: 100, height: 1, color: PdfColors.black)
                  ]),
                  pw.Text(
                    "نام",
                    style:
                        pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.SizedBox(width: 10)
                ],
              ),
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.SizedBox(height: 5 * PdfPageFormat.mm),
            pw.Table.fromTextArray(
              headers: tableHeadersUrdu.reversed
                  .toList(), // Reverse the order of the headers
              data: tableData.toList(),
              border: pw.TableBorder(
                // Set border color for each side
                left: pw.BorderSide(color: PdfColor.fromHex('#023047')),
                top: pw.BorderSide(color: PdfColor.fromHex('#023047')),
                right: pw.BorderSide(color: PdfColor.fromHex('#023047')),
                bottom: pw.BorderSide(color: PdfColor.fromHex('#023047')),
                verticalInside: pw.BorderSide(
                    color: PdfColor.fromHex('#023047')), // Vertical lines
                horizontalInside: pw.BorderSide(
                    color: PdfColor.fromHex('#023047')), // Horizontal lines
              ),
              cellStyle: pw.TextStyle(font: ttf),
              rowDecoration:
                  pw.BoxDecoration(color: PdfColor.fromHex("#F7EBC3")),
              headerStyle: pw.TextStyle(
                font: ttf,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
              headerDecoration:
                  pw.BoxDecoration(color: PdfColor.fromHex("#EFB768")),
              cellHeight: 30.0,
               columnWidths: {
                0: pw.FlexColumnWidth(1),
                1: pw.FlexColumnWidth(1),
                2: pw.FlexColumnWidth(1),
                3: pw.FlexColumnWidth(1),
                4: pw.FlexColumnWidth(1),
                5: pw.FlexColumnWidth(1),
                6: pw.FlexColumnWidth(1),
                7: pw.FlexColumnWidth(1),
              },
              cellAlignments: {
                0: pw.Alignment.center,
                1: pw.Alignment.center,
                2: pw.Alignment.center,
                3: pw.Alignment.center,
                4: pw.Alignment.center,
                5: pw.Alignment.center,
                6: pw.Alignment.center,
                7: pw.Alignment.center,
              },
            ),
            pw.Divider(),
            pw.Column(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
              pw.SizedBox(height: 100),
              pw.Directionality(
                  textDirection: pw.TextDirection.ltr,
                  child: pw.Row(children: [
                    pw.SizedBox(
                        width: 50,
                        child: pw.Text(
                          "${totalBaqaya+ cash.last.price}",
                          style: pw.TextStyle(
                            font: ttf,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textDirection: pw.TextDirection.rtl,
                        )),
                    pw.SizedBox(width: 10),
                    pw.Container(
                      height: 30,
                      width: 70,
                      color: PdfColor.fromHex("#EFB768"),
                      child: pw.Center(
                        child: pw.Text(
                          "جمله بقايا",
                          style: pw.TextStyle(
                            font: ttf,
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 50),
                    pw.SizedBox(
                        width: 50,
                        child: pw.Text(
                          cash.last.price.toString(),
                          style: pw.TextStyle(
                              font: ttf,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.green),
                          textDirection: pw.TextDirection.rtl,
                        )),
                    pw.SizedBox(width: 10),
                    pw.Container(
                      height: 30,
                      width: 70,
                      color: PdfColor.fromHex("#EFB768"),
                      child: pw.Center(
                        child: pw.Text(
                          "نقد وصول",
                          style: pw.TextStyle(
                            font: ttf,
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 50),
                    pw.SizedBox(
                        width: 50,
                        child: pw.Text(
                          totalBaqaya.toString(),
                          style: pw.TextStyle(
                            font: ttf,
                            color: PdfColors.red,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textDirection: pw.TextDirection.rtl,
                        )),
                    pw.SizedBox(width: 10),
                    pw.Container(
                      height: 30,
                      width: 70,
                      color: PdfColor.fromHex("#EFB768"),
                      child: pw.Center(
                        child: pw.Text(
                          "زور حساب",
                          style: pw.TextStyle(
                            font: ttf,
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ),
                    ),
                  ])),
              pw.SizedBox(height: 10),
              pw.Directionality(
                  textDirection: pw.TextDirection.ltr,
                  child: pw.Row(children: [
                    pw.Container(
                      height: 40,
                      width: 70 * 4,
                      color: PdfColor.fromHex("#EFB768"),
                      child: pw.Center(
                          child: pw.Padding(
                        padding: pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text(
                          "ادرس: اوله ناحیه اتحاد مارکیت دویم منزل دکان نمبر 32،33 لشکرگاه، هیلمند افغانستان",
                          style: pw.TextStyle(
                            font: ttf,
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                          textDirection: pw.TextDirection.rtl,
                        ),
                      )),
                    ),
                  ])),
              pw.SizedBox(height: 10),
              pw.Directionality(
                  textDirection: pw.TextDirection.ltr,
                  child: pw.Row(children: [
                    pw.Container(
                      height: 40,
                      width: 70 * 4,
                      color: PdfColor.fromHex("#EFB768"),
                      child: pw.Center(
                          child: pw.Padding(
                        padding: pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text(
                          "SALEH BWARI LTD\nجواز نمبر55708",
                          style: pw.TextStyle(
                            font: ttf,
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                          textDirection: pw.TextDirection.rtl,
                        ),
                      )),
                    ),
                    pw.SizedBox(width: 100),
                    pw.Container(
                      height: 30,
                      width: 70,
                      color: PdfColor.fromHex("#EFB768"),
                      child: pw.Center(
                        child: pw.Text(
                          "دستخط",
                          style: pw.TextStyle(
                            font: ttf,
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ),
                    ),
                  ]))
            ])
          ];
        },
        // footer: (context) {
        //   return pw.SizedBox(
        //     width: double.infinity,
        //     height: 40,
        //     child:
        //         pw.Image(pw.MemoryImage(bottomImage), fit: pw.BoxFit.fitWidth),
        //   );
        // },
      ),
    );

    return FileHandleApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }
}
