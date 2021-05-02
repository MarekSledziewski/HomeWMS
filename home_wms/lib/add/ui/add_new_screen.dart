import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/add/bloc/add_bloc.dart';
import 'package:home_wms/loading_animation.dart';
import 'package:home_wms/model/producer/producer.dart';
import 'package:home_wms/model/products/products.dart';

class AddScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddScreenState();
}

class AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBloc(),
    );
  }

  @override
  void dispose() {
    Hive.box("categories").close();
    Hive.box("producers").close();
    super.dispose();
  }

  late String choosenCategoryValue;
  late List listCategories;
  late Producer choosenProducerValue;
  late List<Producer> listProducers;
  @override
  void initState() {
    listCategories = Hive.box('categories').values.toList();

    listCategories.insert(0, 'Uncategorized');
    choosenCategoryValue = listCategories.first;

    listProducers = Hive.box('producers').values.cast<Producer>().toList();

    listProducers.insert(0, Producer('Producer Unknown', '', ''));
    choosenProducerValue = listProducers.first;
    super.initState();
  }

  final productNameFieldController = TextEditingController();
  final quantityFieldController = TextEditingController();
  final productBarCodeFieldController = TextEditingController();
  final productPriceFieldController = TextEditingController();

  Widget _buildBloc() => BlocBuilder<AddBloc, AddState>(
        builder: (context, state) {
          if (state is InitialAddState) {
            return _buildBody();
          } else if (state is ProductAddingState) {
            return LoadingAnimation();
          } else if (state is ProdcutAddedState) {
            return _buildBody();
          } else if (state is ClearState) {
            return _buildBody();
          } else if (state is ProdcutAddedSimilarState) {
            return _buildBody();
          } else if (state is ProductExsistsState) {
            return _productExsist(state.product);
          } else {
            return _buildBody();
          }
        },
      );

  Widget _buildBody() => ListView(
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

  Widget productNameTextField() => TextField(
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

  Widget productCategoryField() => Container(
      child: DropdownButton(
          isExpanded: true,
          value: choosenCategoryValue,
          onChanged: (value) {
            setState(() {
              choosenCategoryValue = value.toString();
            });
          },
          items: listCategories
              .map((categoryValue) => DropdownMenuItem(
                  value: categoryValue,
                  child: Text(
                    categoryValue,
                  )))
              .toList()));

  Widget productProducerField() => Container(
      child: DropdownButton(
          isExpanded: true,
          value: choosenProducerValue,
          onChanged: (value) {
            setState(() {
              choosenProducerValue = value as Producer;
            });
          },
          items: listProducers
              .map((producerValue) => DropdownMenuItem(
                  value: producerValue,
                  child: Text(
                    producerValue.name,
                  )))
              .toList()));

  Widget productBarCodeTextField() => TextField(
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

  Widget productQuantityField() => TextField(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
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

  Widget productPriceField() => TextField(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9 .]')),
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

  Widget _buildAddButton() => OutlinedButton(
        onPressed: () {
          if (productNameFieldController.text.isEmpty) {
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
          "Add product",
          style: TextStyle(color: Colors.white),
        ),
      );

  _addEvent() {
    if (productPriceFieldController.text.isEmpty ||
        quantityFieldController.text.isEmpty) {
      if (productPriceFieldController.text.isEmpty &&
          quantityFieldController.text.isEmpty) {
        BlocProvider.of<AddBloc>(context).add(AddProductEvent(Product(
          productNameFieldController.text,
          0,
          productBarCodeFieldController.text,
          choosenCategoryValue,
          choosenProducerValue.name,
          0,
        )));
                    _clearFields();

      } else {
        if (productPriceFieldController.text.isEmpty) {
          BlocProvider.of<AddBloc>(context).add(AddProductEvent(Product(
            productNameFieldController.text,
            int.parse(quantityFieldController.text),
            productBarCodeFieldController.text,
            choosenCategoryValue,
            choosenProducerValue.name,
            0,
          )));            _clearFields();

        } else if (quantityFieldController.text.isEmpty) {
          BlocProvider.of<AddBloc>(context).add(AddProductEvent(Product(
            productNameFieldController.text,
            0,
            productBarCodeFieldController.text,
            choosenCategoryValue,
            choosenProducerValue.name,
            double.parse(productPriceFieldController.text),
          )));
                    _clearFields();
}
      }
      Navigator.pop(context);
    } else if (_doubleIsCorrect()) {
      BlocProvider.of<AddBloc>(context).add(AddProductEvent(Product(
        productNameFieldController.text,
        int.parse(quantityFieldController.text),
        productBarCodeFieldController.text,
        choosenCategoryValue,
        choosenProducerValue.name,
        double.parse(productPriceFieldController.text),
      )));
      Navigator.pop(context);
                _clearFields();
} else {
      _correctPrice();
    }
  }

  _doubleIsCorrect() {
    try {
      double.parse(productPriceFieldController.text);
      return true;
    } catch (FormatExeption) {
      return false;
    }
  }

  _correctPrice() => showDialog(
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

  _addConfirmDialog() => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: Text('Add Product?'),
            content: Text('Add your product to the Database'),
            actionsOverflowButtonSpacing: 30,
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
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  if (productBarCodeFieldController.text.isEmpty) {
                    productBarCodeFieldController.text =
                        productNameFieldController.text;
                  }
                  _addEvent();
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
                  "Add",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]),
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
      onPressed: () {
        _scanBarcode();
      });

  Future<void> _scanBarcode() async {
    final String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', 'Return', true, ScanMode.DEFAULT);
    productBarCodeFieldController.text = barcode;
  }

  Widget _productExsist(Product product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Product already exsists'),
        Text('Discard changes, Edit or Add quantiti to same one'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
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
                  "Discar",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  BlocProvider.of<AddBloc>(context).add(EditEvent());
                }),
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
                  "Edit",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  productNameFieldController.text = product.name;
                  quantityFieldController.text = product.quantity.toString();
                  productPriceFieldController.text = product.price.toString();
                  productBarCodeFieldController.text = product.name;
                  if (product.producer == 'Producer Unknown') {
                  } else {
                    choosenProducerValue = Hive.box('producers')
                        .values
                        .cast<Producer>()
                        .firstWhere(
                            (element) => element.name == product.producer);
                  }

                  choosenCategoryValue = product.category;
                  BlocProvider.of<AddBloc>(context).add(EditEvent());
                }),
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
                  "Add",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  BlocProvider.of<AddBloc>(context).add(
                    AddQuanitiEvent(product.quantity, product.name),
                  );            _clearFields();

                })
          ],
        )
      ],
    );
  }

  _clearFields() {
    productNameFieldController.clear();
    quantityFieldController.clear();
    productPriceFieldController.clear();
    productBarCodeFieldController.clear();
    choosenProducerValue = listProducers.first;
    choosenCategoryValue = listCategories.first;
  }

  AppBar _buildAppbar() => AppBar(
        title: (Text("Add New Product")),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      );
}
