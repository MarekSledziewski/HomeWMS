import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/model/producer/producer.dart';
import 'package:home_wms/model/products/products.dart';
import 'package:home_wms/prodcuts_list/bloc/products_list_bloc.dart';

class ProductEditScreen extends StatefulWidget {
  final Product product;

  ProductEditScreen(this.product);

  @override
  State<StatefulWidget> createState() => ProductEditScreenState(product);
}

class ProductEditScreenState extends State<ProductEditScreen> {
  final Product product;

  ProductEditScreenState(this.product);

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBlocBuilder(),
    );
  }

  AppBar _buildAppbar() =>
      AppBar(
        title: (Text("Edit Product")),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
      );

  Widget _buildBlocBuilder() =>
      BlocBuilder<ProductsListBloc, ProductsListState>(
        builder: (context, state) {
          return _buildBody();
        },
      );

  final productNameFieldController = TextEditingController();
  final quantityFieldController = TextEditingController();
  final productBarCodeFieldController = TextEditingController();
  final productPriceFieldController = TextEditingController();
  late String choosenCategoryValue;
  late List listCategories;
  late Producer choosenProducerValue;
  late List<Producer> listProducers;

  @override
  void initState() {
    productNameFieldController.text = product.name;
    quantityFieldController.text = product.quantity.toString();
    productBarCodeFieldController.text = product.barcode;
    productPriceFieldController.text = product.price.toString();

    
    listCategories = Hive.box('categories').values.toList();

    listCategories.insert(0, 'Uncategorized');

    if (Hive
        .box('categories')
        .values
        .any(
            (category) =>
        category.toString().toLowerCase() == product.category.toLowerCase())) 
        {
      choosenCategoryValue = product.category;
    } else {
      choosenCategoryValue = listCategories.first;
    }

    listProducers = Hive
        .box('producers')
        .values
        .cast<Producer>()
        .toList();
    listProducers.insert(0, Producer('Producer Unknown', '', ''));

    if (Hive
        .box('producers')
        .values
        .any((element) =>
    element.name.toString().toLowerCase() == product.producer.toLowerCase())) {
      choosenProducerValue = Hive
          .box('producers')
          .values
          .firstWhere(
              (element) =>
          element.name.toLowerCase() == product.producer.toLowerCase());
    } else {
      choosenProducerValue = listProducers.first;
    }

    choosenProducerValue = listProducers.first;
    super.initState();
  }

  Widget _buildBody() =>
      ListView(
        children: [
          productNameTextField(),
          productCategoryField(),
          productProducerField(),
          productBarCodeTextField(),
          productPriceField(),
          productQuantityField(),
          Row(
            children: [
              _scannerButtonAction(),
              Spacer(),
              _buildAddButton(),
            ],
          ),
        ],
      );

  Widget productNameTextField() =>
      TextField(
          onEditingComplete: () {
            FocusScope.of(context).nextFocus();
          },
          textInputAction: TextInputAction.next,
          maxLength: 100,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          controller: productNameFieldController,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
              counter: Offstage(),
              fillColor: Colors.white,
              border: InputBorder.none,
              labelText: 'Name'));

  Widget productCategoryField() =>
      Container(
          child: DropdownButton(
              isExpanded: true,
              value: choosenCategoryValue,
              onChanged: (value) {
                setState(() {
                  choosenCategoryValue = value.toString();
                });
              },
              items: listCategories
                  .map((categoryValue) =>
                  DropdownMenuItem(
                      value: categoryValue,
                      child: Text(
                        categoryValue,
                      )))
                  .toList()));

  Widget productProducerField() =>
      Container(
          child: DropdownButton(
              isExpanded: true,
              value: choosenProducerValue,
              onChanged: (value) {
                setState(() {
                  choosenProducerValue = value as Producer;
                });
              },
              items: listProducers
                  .map((producerValue) =>
                  DropdownMenuItem(
                      value: producerValue,
                      child: Text(
                        producerValue.name,
                      )))
                  .toList()));

  Widget productBarCodeTextField() =>
      TextField(
          onEditingComplete: () {
            FocusScope.of(context).nextFocus();
          },
          textInputAction: TextInputAction.next,
          maxLength: 100,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          controller: productBarCodeFieldController,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
              counter: Offstage(),
              fillColor: Colors.white,
              border: InputBorder.none,
              labelText: 'Bar Code'));

  Widget productQuantityField() =>
      TextField(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9 .]')),
          ],
          keyboardType: TextInputType.number,
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
          textInputAction: TextInputAction.next,
          maxLength: 20,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          controller: quantityFieldController,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
              counter: Offstage(),
              fillColor: Colors.white,
              border: InputBorder.none,
              labelText: 'Quantity'));

  Widget productPriceField() =>
      TextField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9 ,]')),
          ],
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
          textInputAction: TextInputAction.next,
          maxLength: 20,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          controller: productPriceFieldController,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
              counter: Offstage(),
              fillColor: Colors.white,
              border: InputBorder.none,
              labelText: 'Price'));

  Widget _buildAddButton() =>
      OutlinedButton(
        onPressed: () {
          if (productNameFieldController.text.isEmpty ||
              productPriceFieldController.text.isEmpty ||
              quantityFieldController.text.isEmpty) {
            _emptyFields();
          } else {
            _addConfirmDialog();
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
          "Apply",
          style: TextStyle(color: Colors.white),
        ),
      );

  _addConfirmDialog() =>
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
                actionsOverflowButtonSpacing: 20,

                title: Text('Save Changes?'),
                actions: [

                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                        return Colors.blueAccent;
                      }),
                      overlayColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.blue.shade900;
                        }
                        return Colors.transparent;
                      }),
                    ),
                    child: Text(
                      "Ok",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      if (productBarCodeFieldController.text.isEmpty &&
                          productBarCodeFieldController.text == '-1') {
                        productBarCodeFieldController.text =
                            productNameFieldController.text;
                      }
                      _editEvent(product);
                    },
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
                      "Apply changes",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ]),
      );

  _emptyFields() =>
      showDialog(
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

  _editEvent(product) {
    if (productPriceFieldController.text.isEmpty ||
        quantityFieldController.text.isEmpty) {
      if (productPriceFieldController.text.isEmpty &&
          quantityFieldController.text.isEmpty) {
        BlocProvider.of<ProductsListBloc>(context).add(
            EditProductEvent(product, Product(
              productNameFieldController.text,
              0,
              productBarCodeFieldController.text,
              choosenCategoryValue,
              choosenProducerValue.name,
              0,
            )));
      } else {
        if (productPriceFieldController.text.isEmpty) {
          BlocProvider.of<ProductsListBloc>(context).add(
              EditProductEvent(product, Product(
                productNameFieldController.text,
                int.parse(quantityFieldController.text),
                productBarCodeFieldController.text,
                choosenCategoryValue,
                choosenProducerValue.name,
                0,
              )));
        } else if (quantityFieldController.text.isEmpty) {
          BlocProvider.of<ProductsListBloc>(context).add(
              EditProductEvent(product, Product(
                productNameFieldController.text,
                0,
                productBarCodeFieldController.text,
                choosenCategoryValue,
                choosenProducerValue.name,
                double.parse(productPriceFieldController.text),
              )));
        }
      }
      Navigator.pop(context);
    } else if (_doubleIsCorrect()) {
      BlocProvider.of<ProductsListBloc>(context).add(
          EditProductEvent(product, Product(
            productNameFieldController.text,
            int.parse(quantityFieldController.text),
            productBarCodeFieldController.text,
            choosenCategoryValue,
            choosenProducerValue.name,
            double.parse(productPriceFieldController.text),
          )));
      Navigator.pop(context);
    } else {
      _correctPrice();
    }
  }

  _correctPrice() =>
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              AlertDialog(title: Text('Incorect price value'), actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
                ),
              ]));

  _doubleIsCorrect() {
    try {
      double.parse(productPriceFieldController.text);
      return true;
    } catch (FormatExeption) {
      return false;
    }
  }

  _scannerButtonAction() =>
      OutlinedButton(
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
          onPressed: () {
            _scanBarcode();
          });

  Future<void> _scanBarcode() async {
    final String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', 'Return', true, ScanMode.DEFAULT);
    productBarCodeFieldController.text = barcode;
  }
}
