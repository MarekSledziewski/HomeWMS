import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/add/add/add_bloc.dart';
import 'package:home_wms/model/producer/producer.dart';

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

    if (listCategories.isEmpty) {
      choosenCategoryValue = "";
    } else {
      choosenCategoryValue = listCategories.first;
    }

    listProducers = Hive.box('producers').values.cast<Producer>().toList();
   if (listProducers.isNotEmpty) {
     choosenProducerValue = listProducers.first;
    }
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
          } else if (state is ProdcutAdded) {
            return _buildBody();
          } else {
            return Center(child: Text('Error on Bloc Builder'));
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
          hintText: 'Name'));

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
          hintText: 'Bar Code'));

  Widget productQuantityField() => TextField(
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
          hintText: 'Quantity'));

  Widget productPriceField() => TextField(
      keyboardType: TextInputType.number,
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
          hintText: 'Price'));

  Widget _buildAddButton() => OutlinedButton(
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
          "Add product",
          style: TextStyle(color: Colors.white),
        ),
      );

  _addEvent() => BlocProvider.of<AddBloc>(context).add(AddProductEvent(
      productNameFieldController.text,
      choosenCategoryValue,
      productBarCodeFieldController.text,
      choosenProducerValue.name,
      double.parse(productPriceFieldController.text),
      int.parse(quantityFieldController.text)));

  _addConfirmDialog() => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: Text('Add Product?'),
            content: Text('Add your product to the Database'),
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
                  if (productBarCodeFieldController.text.isEmpty) {
                    productBarCodeFieldController.text =
                        productNameFieldController.text;
                  }
                  _addEvent();
                  productNameFieldController.clear();
                  quantityFieldController.clear();
                  productPriceFieldController.clear();
                  productBarCodeFieldController.clear();
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
                  "Add",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  _addEvent();
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
                  "AddSimilar",
                  style: TextStyle(color: Colors.white),
                ),
              )
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

  AppBar _buildAppbar() => AppBar(
        title: (Text("Add Product")),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      );
}
