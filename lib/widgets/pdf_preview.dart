import 'dart:typed_data';

import 'package:remotesurveyadmin/helper/currency_formatter_util.dart';
import 'package:remotesurveyadmin/views/home/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';

import '../data/mocks/mock_factory.dart';
import '../helper/date_formatter_util.dart';
import '../models/transaction_model.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfPreviewPage extends StatelessWidget {
  final List<UtilityPaymentModel> transactions;
  final String phone;

  final String email;

  final String fullName;

  PdfPreviewPage(
      {Key? key,
      required this.transactions,
      required this.fullName,
      required this.email,
      required this.phone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PdfPreview(
            build: (context) => makePdf(fullName, email, phone, transactions)));
  }

  Future<Uint8List> makePdf(String name, String email, String phone,
      List<UtilityPaymentModel> payments) async {
    var chunks = [];
    int chunkSize = 15;
    for (var i = 0; i < payments.length; i += chunkSize) {
      chunks.add(payments.sublist(
          i,
          i + chunkSize > payments.length
              ? payments.length
              : i + chunkSize));
    }
    final imageLogo = pw.MemoryImage(
        (await rootBundle.load('assets/images/welcome/logo.png'))
            .buffer
            .asUint8List());
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(build: (pw.Context context) {
      return [
        pw.Column(children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                children: [
                  pw.Text("To."),
                  pw.Text("$name "),
                  pw.Text("$phone "),
                  pw.Text(
                      "${DateFormatterUtil().serverFormattedDate(DateTime.now())} "),
                ],
                crossAxisAlignment: pw.CrossAxisAlignment.start,
              ),
              pw.SizedBox(
                height: 150,
                width: 150,
                child: pw.Image(imageLogo),
              ),
            ],
          ),
          pw.Padding(
            child: pw.Text(
              'TRANSACTIONS PRINT OUT',
              style: pw.Theme.of(context).header4,
              textAlign: pw.TextAlign.center,
            ),
            padding: pw.EdgeInsets.all(20),
          ),
          ...chunks.map(
            (model) => pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black),
              children: [
                // The remaining rows contain each item from the invoice, and uses the
                // map operator (the ...) to include these items in the list
                ...model.map(
                  // Each new line item for the invoice should be rendered on a new TableRow
                  (e) => pw.TableRow(
                    children: [
                      pw.Expanded(
                        child: pw.Padding(
                          padding: pw.EdgeInsets.all(10),
                          child: pw.Text(e.transactionCode,
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(fontSize: 10)),
                        ),
                        flex: 1,
                      ),
                      pw.Expanded(
                        child: pw.Padding(
                          padding: pw.EdgeInsets.all(10),
                          child: pw.Text(
                              DateFormatterUtil().serverFormattedDate(e.date),
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(fontSize: 10)),
                        ),
                        flex: 1,
                      ),
                      pw.Expanded(
                        child: pw.Padding(
                          padding: pw.EdgeInsets.all(10),
                          child: pw.Text("${e.transactionType == TransactionType.Payment ? "Payment" : "Recharge"}",
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(fontSize: 10)),
                        ),
                        flex: 1,
                      ),
                      pw.Expanded(
                        child: pw.Padding(
                          padding: pw.EdgeInsets.all(10),
                          child: pw.Text("${e.meter}",
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(fontSize: 10)),
                        ),
                        flex: 1,
                      ),
                      pw.Expanded(
                        child: pw.Padding(
                          padding: pw.EdgeInsets.all(10),
                          child: pw.Text("${e.tokenData.toString().replaceAll("}", "").replaceAll("{", "")}",
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(fontSize: 6)),
                        ),
                        flex: 1,
                      ),
                      pw.Expanded(
                        child: pw.Padding(
                          padding: pw.EdgeInsets.all(10),
                          child: pw.Text(
                              "${CurrencyFormatterUtil().format(value: e.amount)}",
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(fontSize: 10)),
                        ),
                        flex: 1,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.Padding(
            child: pw.Text(
              "Disclaimer: This record is produced for your personal use and is not transferable. In case of any discrepancies, please inform us.",
              style: pw.TextStyle(fontSize: 10),
            ),
            padding: pw.EdgeInsets.all(20),
          ),
        ])
      ];
    }));
    return pdf.save();
  }
}
