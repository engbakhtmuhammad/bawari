import 'package:bawari/view/invoice/file_handle_api.dart';
import 'package:bawari/view/invoice/pdf_invoice_api.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Invoice PDF Generate',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
final tableHeaders = [
      'Description',
      'Quantity',
      'Unit Price',
      'VAT',
      'Total',
    ];

    final tableData = [
      [
        'Coffee',
        '7',
        '\$ 5',
        '1 %',
        '\$ 35',
      ],
      [
        'Blue Berries',
        '5',
        '\$ 10',
        '2 %',
        '\$ 50',
      ],
      [
        'Water',
        '1',
        '\$ 3',
        '1.5 %',
        '\$ 3',
      ],
      [
        'Apple',
        '6',
        '\$ 8',
        '2 %',
        '\$ 48',
      ],
      [
        'Lunch',
        '3',
        '\$ 90',
        '12 %',
        '\$ 270',
      ],
      [
        'Drinks',
        '2',
        '\$ 15',
        '0.5 %',
        '\$ 30',
      ],
      [
        'Lemon',
        '4',
        '\$ 7',
        '0.5 %',
        '\$ 28',
      ],
    ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            
            ElevatedButton(
              onPressed: () async {
                // generate pdf file
                final pdfFile = await PdfInvoiceApi.generate(
                  PdfColors.blue,
                  pw.Font.courier(),tableHeaders, tableData
                );

                // opening the pdf file
                FileHandleApi.openFile(pdfFile);
              },
              child: const Text('Generate Invoice'),
            ),
          ],
        ),
      ),
    );
  }
}
