import 'dart:io';
import 'package:bawari/model/purchase_model.dart';
import 'package:bawari/model/sale_model.dart';
import 'package:flutter/services.dart';
import 'file_handle_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PurchaseInvoicePdf {
  static Future<File> generate(
      {required PurchaseModel purchase}) async {
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
      'Carton Qty',
      'Cartoon Price',
      'Total Qty',
      'Price',
      'Total Amount'
    ];
    final tableHeadersUrdu = [
      'تفصيل',
      'کارتن تعداد',
      'یو کارتن قیمت',
      'جمله تعداد',
      'قیمت',
      'جمله قیمت'
    ];

    final tableData = [
      [
        purchase.name,
        purchase.cartonCount.toString(),
        purchase.perCartonCount.toString(),
        purchase.totalCount.toString(),
        purchase.price.toString(),
        "${int.parse(purchase.price.toString())*int.parse(purchase.totalCount.toString())}"
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
            pw.Directionality(textDirection: pw.TextDirection.ltr,child: pw.Row(
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
                  "     ${purchase.billNo.toString()}     ",
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
            ),),
            pw.Directionality(textDirection: pw.TextDirection.ltr,child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  " حاجی صالح محمد باوری ",
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
            ),),
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
              headers: tableHeadersUrdu.reversed
                  .toList(), // Reverse the order of the headers
              data: tableData
                  .map((row) => row.reversed.toList())
                  .toList(), // Reverse the order of the data rows
              border: null,
              rowDecoration:
                  pw.BoxDecoration(color: PdfColor.fromHex("#F7EBC3")),
              headerStyle: pw.TextStyle(
                font: ttf,
                  fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration:
                  pw.BoxDecoration(color: PdfColor.fromHex("#EFB768")),
              cellHeight: 30.0,
              cellAlignments: {
                0: pw.Alignment.centerRight,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerLeft,
                4: pw.Alignment.centerLeft,
                5: pw.Alignment.centerLeft,
                6: pw.Alignment.centerLeft,
              },
            ),
            pw.Divider(),
            pw.Column(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
              pw.SizedBox(height: 100),
              pw.Directionality(child: pw.Row(children: [
                pw.SizedBox(
                  width: 50,
                  child: pw.Text(
                  "${int.parse(purchase.price.toString())*int.parse(purchase.totalCount.toString())}",
                  style: pw.TextStyle(
                    font: ttf,
                    fontWeight: pw.FontWeight.bold,
                    
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),),
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
                        
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ),
                ),
                pw.SizedBox(width: 70),
                pw.SizedBox(width: 50,child: pw.Text(
                  purchase.cartonCount.toString(),
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
                      "کارتن تعداد",
                      style: pw.TextStyle(
                        font: ttf,
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ),
                ),
              ]), textDirection: pw.TextDirection.ltr,),
              pw.SizedBox(height: 10),
              pw.Directionality(textDirection: pw.TextDirection.ltr,child: pw.Row(children: [
                pw.SizedBox(width: 50,child: pw.Text(
                  "${int.parse(purchase.price.toString())*int.parse(purchase.totalCount.toString())}",
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
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        
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
                        
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ),
                ),
              ])),
              pw.SizedBox(height: 10),
              pw.Directionality(textDirection: pw.TextDirection.ltr,child: pw.Row(children: [
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
                        
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ),
                ),
              ])),
              pw.SizedBox(height: 10),
              pw.Directionality(textDirection: pw.TextDirection.ltr,child: pw.Row(children: [
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
                        
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ),
                ),
              ]))
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
