import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:home_wms/model/products/products.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../loading_animation.dart';

class PdfOrder extends StatelessWidget {
  final pdf = pw.Document();
  late final String pdfPath;
  final List<Product> _listOfProducts;
  final List<List<String>> _arrayList = [];
  final List<String> _productHeaders = (['Name', 'Category', 'Producer', 'Quanity', 'Price', 'Barcode']);

  PdfOrder(this._listOfProducts) {
    _createPdf();
    _savePDF();
  }
  _createPdf() {
    pdf.addPage(pw.Page(
        build: (pw.Context context) => pw.Column(children: [
              pw.Table.fromTextArray(data: _arrayList,
               context: context,
               border: pw.TableBorder.all(),
              headerAlignment: pw.Alignment.center,
              headers: _productHeaders,
              
              )
            ])));
  }

  Future _savePDF() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentpath = documentDirectory.path;
    File file = File("$documentpath/example.pdf");
    file.writeAsBytesSync(await pdf.save());
  }

  _setPath() async {
    await _generateListOfProducts();
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentpath = documentDirectory.path;
    pdfPath = "$documentpath/example.pdf";
  }

  _generateListOfProducts() {
    for (int i = 0; i < _listOfProducts.length; i++) {
      List<String> tempList = [
        _listOfProducts[i].name,
        _listOfProducts[i].category,
        _listOfProducts[i].producer,
        _listOfProducts[i].quantity.toString(),
        _listOfProducts[i].price.toString(),
        _listOfProducts[i].barcode,
      ];
      _arrayList.add(tempList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _setPath(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return throw (snapshot.error.toString());
            } else {
              return PDFView(filePath: pdfPath,);
            }
          }
          return LoadingAnimation();
        });
  }
}
