import 'dart:io';
import 'package:flutter/services.dart';
import 'file_handle_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfInvoiceApi {
  static Future<File> generate({required String particulars,required String pieces,required String cartonCount, 
  required String perCartonCount,required String totalCount,required String perPrice,required String totalPrice,
  required String customerName,required String billNo,required String dues,required String credit, required String billTotal, required String totalBagaya}) async {
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
    final tableHeadersUrdu=[
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
     particulars,
     pieces,
     cartonCount,
     perCartonCount,
     totalCount,
     perPrice,
     totalPrice
    ],
  ];

    pdf.addPage(
      pw.MultiPage(
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
                  "____________",
                  style: pw.TextStyle(
                    font: ttf,
                    decoration: pw.TextDecoration.underline,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.Text(
                  DateTime.now().toString(),
                  style: pw.TextStyle(
                    font: ttf,
                    decoration: pw.TextDecoration.underline,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(width: 3),
                pw.Text(
                  billNo,
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
                    decoration: pw.TextDecoration.underline,
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
                  customerName,
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
                    decoration: pw.TextDecoration.underline,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
              ],
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            // pw.Text(
            //   'Dear John,\nLorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia, molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium optio, eaque rerum! Provident similique accusantium nemo autem. Veritatis obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam nihil, eveniet aliquid culpa officia aut! Impedit sit sunt quaerat, odit, tenetur error',
            //   textAlign: pw.TextAlign.justify,
            //   style: pw.TextStyle(
            //     fontSize: 14.0,
            //     color: color,
            //     font: fontFamily,
            //   ),
            // ),
            pw.SizedBox(height: 5 * PdfPageFormat.mm),

            ///
            /// PDF Table Create
            ///
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
                  fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration:
                  pw.BoxDecoration(color: PdfColor.fromHex("#FFB703")),
              cellHeight: 30.0,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerRight,
              },
            ),
            pw.Divider(),
            pw.Column(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
              pw.SizedBox(height: 100),
              pw.Row(children: [
                pw.Text(
                  billTotal,
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
                  cartonCount,
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
                  dues,
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
                  credit,
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
                totalBagaya,
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

            // pw.Container(
            //   alignment: pw.Alignment.centerRight,
            //   child: pw.Row(
            //     children: [
            //       pw.Spacer(flex: 6),
            //       pw.Expanded(
            //         flex: 4,
            //         child: pw.Column(
            //           crossAxisAlignment: pw.CrossAxisAlignment.start,
            //           children: [
            //             pw.Row(
            //               children: [
            //                 pw.Expanded(
            //                   child: pw.Text(
            //                     'Net total',
            //                     style: pw.TextStyle(
            //                       fontWeight: pw.FontWeight.bold,
            //                       color: color,
            //                       font: fontFamily,
            //                     ),
            //                   ),
            //                 ),
            //                 pw.Text(
            //                   '\$ 464',
            //                   style: pw.TextStyle(
            //                     fontWeight: pw.FontWeight.bold,
            //                     color: color,
            //                     font: fontFamily,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             pw.Row(
            //               children: [
            //                 pw.Expanded(
            //                   child: pw.Text(
            //                     'Vat 19.5 %',
            //                     style: pw.TextStyle(
            //                       fontWeight: pw.FontWeight.bold,
            //                       color: color,
            //                       font: fontFamily,
            //                     ),
            //                   ),
            //                 ),
            //                 pw.Text(
            //                   '\$ 90.48',
            //                   style: pw.TextStyle(
            //                     fontWeight: pw.FontWeight.bold,
            //                     color: color,
            //                     font: fontFamily,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             pw.Divider(),
            //             pw.Row(
            //               children: [
            //                 pw.Expanded(
            //                   child: pw.Text(
            //                     'Total amount due',
            //                     style: pw.TextStyle(
            //                       fontSize: 14.0,
            //                       fontWeight: pw.FontWeight.bold,
            //                       color: color,
            //                       font: fontFamily,
            //                     ),
            //                   ),
            //                 ),
            //                 pw.Text(
            //                   '\$ 554.48',
            //                   style: pw.TextStyle(
            //                     fontWeight: pw.FontWeight.bold,
            //                     color: color,
            //                     font: fontFamily,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             pw.SizedBox(height: 2 * PdfPageFormat.mm),
            //             pw.Container(height: 1, color: PdfColors.grey400),
            //             pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
            //             pw.Container(height: 1, color: PdfColors.grey400),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ];
        },
        footer: (context) {
          return pw.SizedBox(
            width: double.infinity,
            height: 100,
            child:
                pw.Image(pw.MemoryImage(bottomImage), fit: pw.BoxFit.fitWidth),
          );

          // return pw.Column(
          //   mainAxisSize: pw.MainAxisSize.min,
          //   children: [
          //     pw.Divider(),
          //     pw.SizedBox(height: 2 * PdfPageFormat.mm),
          //     pw.Text(
          //       'Flutter Approach',
          //       style:
          //           pw.TextStyle(fontWeight: pw.FontWeight.bold, color: color, font: fontFamily),
          //     ),
          //     pw.SizedBox(height: 1 * PdfPageFormat.mm),
          //     pw.Row(
          //       mainAxisAlignment: pw.MainAxisAlignment.center,
          //       children: [
          //         pw.Text(
          //           'Address: ',
          //           style: pw.TextStyle(
          //               fontWeight: pw.FontWeight.bold, color: color, font: fontFamily),
          //         ),
          //         pw.Text(
          //           'Merul Badda, Anandanagor, Dhaka 1212',
          //           style: pw.TextStyle(color: color, font: fontFamily),
          //         ),
          //       ],
          //     ),
          //     pw.SizedBox(height: 1 * PdfPageFormat.mm),
          //     pw.Row(
          //       mainAxisAlignment: pw.MainAxisAlignment.center,
          //       children: [
          //         pw.Text(
          //           'Email: ',
          //           style: pw.TextStyle(
          //               fontWeight: pw.FontWeight.bold, color: color, font: fontFamily),
          //         ),
          //         pw.Text(
          //           'flutterapproach@gmail.com',
          //           style: pw.TextStyle(color: color, font: pw.Font.courier()),
          //         ),
          //       ],
          //     ),
          //   ],
          // );
        },
      ),
    );

    return FileHandleApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }
}
