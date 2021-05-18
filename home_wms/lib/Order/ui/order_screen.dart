import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:home_wms/Order/PdfOrder.dart';
import 'package:home_wms/Order/auto_complete_order.dart';
import 'package:home_wms/Order/bloc/order_bloc.dart';
import 'package:home_wms/loading_animation.dart';
import 'package:home_wms/model/products/products.dart';

class OrderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen> {
  String barcode = '';
  Product _productClipboard = Product("", 0, "", "", "", 0);
  final nameFieldTextController = TextEditingController();
  final quantityFieldController = TextEditingController(text: '0');
  List<Product> _listOfProductsInBasket = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBloc(),
    );
  }

  AppBar _buildAppbar() => AppBar(
        title: (Text("Order")),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      );

  Widget _buildBloc() =>
      BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
        if (state is OrderInitial) {
          return _buildBody();
        } else if (state is ProdcutFindedState) {
          nameFieldTextController.text = state.product.name;
          _productClipboard = state.product;
          return _buildBody();
        } else if (state is LoadingOrderState) {
          return LoadingAnimation();
        } else if (state is RefreshOrderState) {
          return _buildBody();
        } else if (state is AddToBasketState) {
          if (_elementExsistOnList(state.tempProduct)) {
            _listOfProductsInBasket[_listOfProductsInBasket.indexWhere(
                    (element) => element.name == state.tempProduct.name)] =
                state.tempProduct;
          } else {
            _listOfProductsInBasket.add(state.tempProduct);
          }
          return _buildBody();
        } else
          return _buildBody();
      });

  Widget _buildBody() => Column(
        children: [
          _nameTextField(),
          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Name: "),
                      Text("Category: "),
                      Text("Producer: "),
                      Text("Quantity: "),
                      Text("Price: ")
                    ],
                  ),
                  Column(
                    children: [
                      Text(_productClipboard.name),
                      Text(_productClipboard.category),
                      Text(_productClipboard.producer),
                      Text(_productClipboard.quantity.toString()),
                      Text(_productClipboard.price.toString())
                    ],
                  ),
                  _quantity(),
                ]),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_scannerButtonAction(), _pdfButton(), _addToBasket()]),
          _basketList(),
        ],
      );
  Widget _nameTextField() => TypeAheadField<Product>(
        suggestionsCallback: (pattern) async =>
            AutoCompleteOrderProduct().getProductNameSuggestions(pattern),
        textFieldConfiguration: TextFieldConfiguration(
            controller: nameFieldTextController,
            decoration: InputDecoration(
              labelText: 'Product name',
              border: OutlineInputBorder(),
            )),
        itemBuilder: (context, suggestions) =>
            ListTile(title: Text(suggestions.name)),
        onSuggestionSelected: (Product suggestion) {
          _productClipboard = suggestion;
          nameFieldTextController.text = suggestion.name;
          BlocProvider.of<OrderBloc>(context).add(RefreshOrderEvent());
        },
      );

  Widget _scannerButtonAction() => OutlinedButton(
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
        BlocProvider.of<OrderBloc>(context).add(FindByScanner(barcode));
      });

  Widget _pdfButton() => OutlinedButton(
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
        "Generate Pdf",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => PdfOrder(_listOfProductsInBasket)));
      });

  Widget _addToBasket() => OutlinedButton(
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
        "Add to basket",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        int _quanity = 0;
        if (_elementExsistOnList(_productClipboard)) {
          _quanity = _listOfProductsInBasket
              .firstWhere((element) => element.name == _productClipboard.name)
              .quantity;
        }
        BlocProvider.of<OrderBloc>(context).add(AddToBasket(_productClipboard,
            int.parse(quantityFieldController.text), _quanity));
      });

  Widget _basketList() => Expanded(
      child: Container(
          child: ListView.builder(
              itemCount: _listOfProductsInBasket.length,
              itemBuilder: (context, index) =>
                  _listTile(_listOfProductsInBasket[index]))));

  Widget _listTile(Product product) => Slidable(
          actions: <Widget>[
            IconSlideAction(
                caption: 'Delete',
                color: Colors.blue,
                icon: Icons.delete,
                onTap: () => {
                      _listOfProductsInBasket.removeWhere(
                          (element) => element.name == product.name)
                    })
          ],
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1)),
                ],
              ),
              child: ListTile(
                  minVerticalPadding: 2,
                  title: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 4)),
                        ],
                      ),
                      child: Column( children: [ 
                      Text(product.name, textAlign: TextAlign.center,),
                      Table(
                    children: [
                      TableRow(children:[
                        Text('Category: '),
                        Text(product.category, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('Quantity: '),
                        Text(product.quantity.toString(), maxLines: 1, overflow: TextOverflow.ellipsis)

                      ] ),
                      TableRow(children:[
                        Text('Producer: '),
                        Text(product.producer, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('Price: '),
                        Text(product.price.toString(), maxLines: 1, overflow: TextOverflow.ellipsis),] ),

                    ],

                    )
                    ]
                      )))));

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
    if (int.parse(quantityFieldController.text) + i >= 0) {
      quantityFieldController.text =
          (int.parse(quantityFieldController.text) + i).toString();
    }
  }

  _elementExsistOnList(element) {
    return _listOfProductsInBasket.any((value) => value.name == element.name);
  }

  Future<void> _scanBarcode() async {
    final String _barcode = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', 'Return', true, ScanMode.DEFAULT);
    barcode = _barcode;
  }
}
