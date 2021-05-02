import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:home_wms/add/auto_complete.dart';
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
  final quantityFieldController = TextEditingController(text: '0');

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
        } else if (state is ProdcutAddedState) {
          quantityFieldController.text = '0';
          nameFieldTextController.clear();
          return _buildBody();
        } else if (state is RefreshAddState) {
          return _buildBody();
        } else if (state is ProdcutFindedState) {
          nameFieldTextController.text = state.product.name;
          product = state.product;
          return _buildBody();
        } else {
          return _buildBody();
        }
      });

  _buildBody() => Column(
        children: [
          _nameTextField(),
          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("Category: " + product.category),
                      Text("Producer: " + product.producer),
                      Text("Price: " + product.price.toString())
                    ],
                  ),
                  _quantity(),
                ]),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_scannerButtonAction(), _buildAddButton()]),
        ],
      );
  _nameTextField() => TypeAheadField<Product>(
        suggestionsCallback: (pattern) async =>
            AutoCompleteProduct.getProductNameSuggestions(pattern),
        textFieldConfiguration: TextFieldConfiguration(
            controller: nameFieldTextController,
            decoration: InputDecoration(
              labelText: 'Product name',
              border: OutlineInputBorder(),
            )),
        itemBuilder: (context, suggestions) =>
            ListTile(title: Text(suggestions.name)),
        onSuggestionSelected: (Product suggestion) {
          product = suggestion;
          nameFieldTextController.text = suggestion.name;
          BlocProvider.of<AddBloc>(context).add(RefreshAddEvent());
        },
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
  Widget _quantity() => Column(children: [
        IconButton(
            icon: Icon(Icons.arrow_drop_up),
            onPressed: () => _quantityChange(1)),
        Container(
            width: 100.0,
            child: TextField(
              controller: quantityFieldController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
            )),
        IconButton(
            icon: Icon(Icons.arrow_drop_down),
            onPressed: () => _quantityChange(-1)),
      ]);

  _quantityChange(int i) {
    quantityFieldController.text =
        (int.parse(quantityFieldController.text) + i).toString();
  }

  Future<void> _scanBarcode() async {
    final String _barcode = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', 'Return', true, ScanMode.DEFAULT);
    barcode = _barcode;
  }

  Widget _buildAddButton() => OutlinedButton(
        onPressed: () {
          if (nameFieldTextController.text.isEmpty) {
            _emptyFields();
          } else {
            _addQuantity();
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            return Colors.redAccent;
          }),
          overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.red.shade900;
            }
            return Colors.transparent;
          }),
        ),
        child: Text(
          "Add product",
          style: TextStyle(color: Colors.white),
        ),
      );

  _emptyFields() => showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(title: Text('Fill requaierd fields'), actions: [
            OutlinedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    return Colors.redAccent;
                  }),
                  overlayColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.red.shade900;
                    }
                    return Colors.transparent;
                  }),
                ),
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                })
          ]));

  _addQuantity() => BlocProvider.of<AddBloc>(context).add(AddQuanitiEvent(
      int.parse(quantityFieldController.text), nameFieldTextController.text));
}
