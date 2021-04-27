import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_wms/add/bloc/add_bloc.dart';
import 'package:home_wms/loading_animation.dart';
import 'package:home_wms/model/products/products.dart';

class AddToExsisting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddToExsistingState();
}

class AddToExsistingState extends State<AddToExsisting> {
  String barcode = '';
  Product product = Product("", 0, "", "", "", 0);
  final nameFieldTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBloc(),
    );
  }

  AppBar _buildAppbar() => AppBar(
        title: (Text("Add Product")),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      );

  Widget _buildBloc() =>
      BlocBuilder<AddBloc, AddState>(builder: (context, state) {
        if (state is InitialAddState) {
          return _buildBody();
        } else if (state is ProductAddingState) {
          return LoadingAnimation();
        } else if (state is ProdcutFindedState) {
          nameFieldTextController.text = state.product.name;
          product = state.product;
          return _buildBody();
        } else {
          return Center(child: Text('Error on Bloc Builder'));
        }
      });

  _buildBody() => Column(
        children: [
          _nameTextField(),
          Container(
            child: Column(
              children: [
                Text("Category: " + product.category),
                Text("Producer: " + product.producer),
                Text("Price: " + product.price.toString())
              ],
            ),
          ),
          _scannerButtonAction()
        ],
      );
  _nameTextField() => TextField(
        controller: nameFieldTextController,
      );

  _scannerButtonAction() => OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          return Colors.amberAccent;
        }),
        overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.amber.shade900;
          }
          return Colors.transparent;
        }),
      ),
      child: Text(
        "Scann",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async {
        await _scanBarcode();
        BlocProvider.of<AddBloc>(context).add(FindByScanner(barcode));
      });

  Future<void> _scanBarcode() async {
    final String _barcode = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', 'Return', true, ScanMode.DEFAULT);
    barcode = _barcode;
  }
}
