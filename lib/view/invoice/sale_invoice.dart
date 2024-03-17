import 'dart:io';
import 'package:bawari/model/sale_model.dart';
import 'package:flutter/services.dart';
import 'file_handle_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SaleInvoicePdf {
  static Future<File> generate(
      {required SaleModel sale, required String baqaya}) async {
    final pdf = pw.Document();

    final topImage = (await rootBundle.load('assets/images/bawari_top.png'))
        .buffer
        .asUint8List();
    final bottomImage =
        (await rootBundle.load('assets/images/bawari_bottom.png'))
            .buffer
            .asUint8List();
    // Load the font file for 'Noto Naskh Arabic'
    final fontData = await rootBundle.load('assets/fonts/Almarai-Regular.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    final tableHeaders = [
      'Particulars',
      'Pieces',
      'Carton Qty',
      'Cartoon Price',
      'Total Qty',
      'Price',
      'Total Amount'
    ];
    final tableHeadersUrdu = [
      'تفصيل',
      'بيس تعداد',
      'کارتن تعداد',
      'یو کارتن قیمت',
      'جمله تعداد',
      'قیمت',
      'جمله قیمت'
    ];

    final tableData = [
      [
        sale.name,
        sale.pieceCount.toString(),
        sale.cartonCount.toString(),
        sale.perCartonCount.toString(),
        sale.totalCount.toString(),
        sale.price.toString(),
        sale.totalPrice.toString()
      ],
    ];

    pdf.addPage(
      pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
        build: (context) {
          return [
            pw.SizedBox(
              width: double.infinity,
              height: 120,
              child: pw.Image(pw.MemoryImage(topImage), fit: pw.BoxFit.fill),
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  "     ${DateTime.now().toString()}     ",
                  style: pw.TextStyle(
                    font: ttf,
                    decoration: pw.TextDecoration.underline,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.Text(
                  "تاریخ",
                  style: pw.TextStyle(
                    font: ttf,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(width: 3),
                pw.Text(
                  "     ${sale.billNo.toString()}     ",
                  style: pw.TextStyle(
                    font: ttf,
                    decoration: pw.TextDecoration.underline,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.Text(
                  "بل نمبر",
                  style: pw.TextStyle(
                    font: ttf,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(width: 3)
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  "     ${sale.customerName.toString()}     ",
                  style: pw.TextStyle(
                    font: ttf,
                    decoration: pw.TextDecoration.underline,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.Text(
                  "نام",
                  style: pw.TextStyle(
                    font: ttf,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
              ],
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.SizedBox(height: 5 * PdfPageFormat.mm),
            pw.Table.fromTextArray(
              headers: tableHeaders.reversed.toList(),
              data: [],
              border: null,
              rowDecoration:
                  pw.BoxDecoration(color: PdfColor.fromHex("#F7EBC3")),
              headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration:
                  pw.BoxDecoration(color: PdfColor.fromHex("#023047")),
              cellHeight: 30.0,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerRight,
              },
            ),
            pw.Table.fromTextArray(
              data: tableData.map((row) => row.reversed.toList()).toList(),
              cellAlignments: {
                for (int i = 0; i < tableHeadersUrdu.length; i++)
                  i: pw.Alignment.centerRight,
              },
              cellStyle: pw.TextStyle(font: ttf),
              headerCount: 1,
              headers: tableHeadersUrdu.reversed.toList(),
              headerAlignment: pw.Alignment.centerRight,
              headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                  font: ttf),
              headerDecoration:
                  pw.BoxDecoration(color: PdfColor.fromHex("#FFB703")),
              rowDecoration:
                  pw.BoxDecoration(color: PdfColor.fromHex("#F7EBC3")),
              border: pw.TableBorder(
                left: pw.BorderSide(),
                right: pw.BorderSide(),
                top: pw.BorderSide(),
                bottom: pw.BorderSide(),
                horizontalInside: pw.BorderSide(),
                verticalInside: pw.BorderSide(),
              ),
            ),
            pw.Divider(),
            pw.Column(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
              pw.SizedBox(height: 100),
              pw.Row(children: [
                pw.Text(
                  sale.totalPrice.toString(),
                  style: pw.TextStyle(
                    font: ttf,
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(width: 10),
                pw.Container(
                  height: 30,
                  width: 70,
                  color: PdfColor.fromHex("#EFB768"),
                  child: pw.Center(
                    child: pw.Text(
                      "بل تونل",
                      style: pw.TextStyle(
                        font: ttf,
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.underline,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ),
                ),
                pw.SizedBox(width: 70),
                pw.Text(
                  sale.cartonCount.toString(),
                  style: pw.TextStyle(
                    font: ttf,
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(width: 10),
                pw.Container(
                  height: 30,
                  width: 70,
                  color: PdfColor.fromHex("#EFB768"),
                  child: pw.Center(
                    child: pw.Text(
                      "کارتن تعداد",
                      style: pw.TextStyle(
                        font: ttf,
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.underline,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ),
                ),
              ]),
              pw.SizedBox(height: 10),
              pw.Row(children: [
                pw.Text(
                  baqaya,
                  style: pw.TextStyle(
                    font: ttf,
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(width: 10),
                pw.Container(
                  height: 30,
                  width: 70,
                  color: PdfColor.fromHex("#EFB768"),
                  child: pw.Center(
                    child: pw.Text(
                      "روز حساب",
                      style: pw.TextStyle(
                        font: ttf,
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.underline,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ),
                ),
                pw.SizedBox(width: 70),
                pw.Text(
                  sale.recievedCash.toString(),
                  style: pw.TextStyle(
                    font: ttf,
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
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
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.underline,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ),
                ),
              ]),
              pw.SizedBox(height: 10),
              pw.Row(children: [
                pw.Text(
                  "${sale.totalPrice! + int.parse(baqaya)}",
                  style: pw.TextStyle(
                    font: ttf,
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
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
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.underline,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ),
                ),
                pw.SizedBox(width: 200),
                pw.Container(
                  height: 30,
                  width: 70,
                  color: PdfColor.fromHex("#EFB768"),
                  child: pw.Center(
                    child: pw.Text(
                      "دستخط",
                      style: pw.TextStyle(
                        font: ttf,
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.underline,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ),
                ),
              ]),
              pw.SizedBox(height: 10),
              pw.Row(children: [
                pw.Container(
                  height: 30,
                  width: 70 * 4,
                  color: PdfColor.fromHex("#EFB768"),
                  child: pw.Center(
                    child: pw.Text(
                      "Salih اکاونٹ نمبر عزیزی بانک",
                      style: pw.TextStyle(
                        font: ttf,
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.underline,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ),
                ),
              ]),
              pw.SizedBox(height: 10),
              pw.Row(children: [
                pw.Container(
                  height: 30,
                  width: 70 * 4,
                  color: PdfColor.fromHex("#EFB768"),
                  child: pw.Center(
                    child: pw.Text(
                      "008301201346923",
                      style: pw.TextStyle(
                        font: ttf,
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.underline,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ),
                ),
              ])
            ])
          ];
        },
        footer: (context) {
          return pw.SizedBox(
            width: double.infinity,
            height: 100,
            child:
                pw.Image(pw.MemoryImage(bottomImage), fit: pw.BoxFit.fitWidth),
          );
        },
      ),
    );

    return FileHandleApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }
}
