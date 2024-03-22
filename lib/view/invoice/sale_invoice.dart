import 'dart:io';
import 'package:bawari/controller/credit_controller.dart';
import 'package:bawari/controller/customer_controller.dart';
import 'package:bawari/model/sale_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'file_handle_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SaleInvoicePdf {
  static Future<File> generate({required SaleModel sale}) async {
    final pdf = pw.Document();

    CreditController creditController = Get.put(CreditController());
    CustomerController customerController = Get.put(CustomerController());
    final baqaya =
        await creditController.getTotalDuesByName(sale.customerName.toString());
    var customer = await customerController
        .getCustomerByName(sale.customerName.toString());
    final topImage = (await rootBundle.load('assets/images/top.png'))
        .buffer
        .asUint8List();
    final bottomImage =
        (await rootBundle.load('assets/images/address.png'))
            .buffer
            .asUint8List();
    // Load the font file for 'Noto Naskh Arabic'
    final fontData = await rootBundle.load('assets/fonts/Almarai-Regular.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    final tableHeaders = [
      "No",
      'Particulars',
      'Pieces',
      'Carton Qty',
      'Cartoon Price',
      'Total Qty',
      'Price',
      'Total Amount'
    ];
    final tableHeadersUrdu = [
      "شمارہ",
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
        '1',
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
                      "     ${sale.billNo.toString()}     ",
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
                  pw.Column(children: [
                    pw.Text(
                      "     ${customer!.phone.toString()}     ",
                      style: pw.TextStyle(
                        font: ttf,color: PdfColors.red
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                    pw.SizedBox(height: 2),
                    pw.Container(width: 100, height: 1, color: PdfColors.black)
                  ]),
                  pw.Text(
                    "تلفون شمارہ",
                    style:
                        pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.SizedBox(width: 10),
                  pw.Column(children: [
                    pw.Text(
                      "     ${customer.address.toString()}     ",
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
                      "     ${sale.customerName.toString()}     ",
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
            ),
            pw.Table.fromTextArray(
              headers: tableHeadersUrdu.reversed
                  .toList(), // Reverse the order of the headers
              data: tableData
                  .map((row) => row.reversed.toList())
                  .toList(), // Reverse the order of the data rows
              border: pw.TableBorder(
                  verticalInside:
                      pw.BorderSide(color: PdfColor.fromHex("#D3D3D3"))),
              rowDecoration:
                  pw.BoxDecoration(color: PdfColor.fromHex("#F7EBC3")),
              headerStyle: pw.TextStyle(
                  font: ttf,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black,),
              headerDecoration:
                  pw.BoxDecoration(color: PdfColor.fromHex("#EFB768")),
              cellHeight: 30.0,

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
                child: pw.Row(children: [
                  pw.SizedBox(
                    width: 50,
                    child: pw.Text(
                      sale.totalPrice.toString(),
                      style: pw.TextStyle(
                        font: ttf,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
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
                          color: PdfColors.black,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                    ),
                  ),
                  
                ]),
                textDirection: pw.TextDirection.ltr,
              ),
              pw.SizedBox(height: 10),
              pw.Directionality(
                  textDirection: pw.TextDirection.ltr,
                  child: pw.Row(children: [
                    pw.SizedBox(
                        width: 50,
                        child: pw.Text(
                          baqaya.toString(),
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
                  pw.Directionality(textDirection: pw.TextDirection.ltr,child: pw.Row(children: [
                    pw.SizedBox(
                        width: 50,
                        child: pw.Text(
                          sale.recievedCash.toString(),
                          style: pw.TextStyle(
                            font: ttf,
                            fontWeight: pw.FontWeight.bold,color: PdfColors.green
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
                  ])),
              pw.SizedBox(height: 10),
              pw.Directionality(
                  textDirection: pw.TextDirection.ltr,
                  child: pw.Row(children: [
                    pw.SizedBox(
                        width: 50,
                        child: pw.Text(
                          "${sale.totalPrice! + double.parse(baqaya.toString())}",
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
                        child: pw.Padding(padding: pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text(
                          "ادرس: اوله ناحیه اتحاد مارکیت دویم منزل دکان نمبر 32،33 لشکرگاه، هیلمند افغانستان",
                          style: pw.TextStyle(
                            font: ttf,
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                          textDirection: pw.TextDirection.rtl,
                        ),)
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
                        child: pw.Padding(padding: pw.EdgeInsets.symmetric(horizontal: 10),
                        child: pw.Text(
                          "SALEH BWARI LTD\nجواز نمبر55708",
                          style: pw.TextStyle(
                            font: ttf,
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                          textDirection: pw.TextDirection.rtl,
                        ),)
                      ),
                    ),
                    pw.SizedBox(
                      width: 50,
                      child: pw.Text(
                        sale.cartonCount.toString(),
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
                          color: PdfColors.black,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                    ),
                  ),
                   pw.SizedBox(width: 60),
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
