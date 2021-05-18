import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/model/products/products.dart';
import 'package:meta/meta.dart';

part 'add_event.dart';

part 'add_state.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  AddBloc() : super(InitialAddState());

  @override
  Stream<AddState> mapEventToState(AddEvent event) async* {

    if (event is AddProductEvent) {
      yield ProductAddingState();
      await Hive.openBox('products');

      Box productBox = Hive.box('products');
      Product product = event.product;

      if (productBox.values.any((element) =>
          element.name.replaceAll(" ", "").toLowerCase() ==
          event.product.name.replaceAll(" ", "").toLowerCase())) {
        {
          product.name = event.product.name[0].toUpperCase() +
              event.product.name.substring(1);
          productBox.add(product);
        }
        
        Hive.box('products').close();

        yield ProdcutAddedState();
      } else {
        yield ProductExsistsState(product);
      }
    } else if (event is FindByScanner) {
      yield ProductAddingState();
      yield ProdcutFindedState(_findProductByScanner(event));
    } else if (event is RefreshAddEvent) {
      yield RefreshAddState();
    } else if (event is EditEvent) {
      yield ProdcutAddedSimilarState();
    } else if (event is AddQuanitiEvent) {
      yield ProductAddingState();
      _addQuantity(event);
      yield ProdcutAddedState();
    }
  }

  _addQuantity(event) {
    print('adding Quantity');
    Map productBox = Hive.box('products').toMap();
    if (productBox.values.any((product) => product.name == event.name)) {
      var index = productBox.keys.firstWhere((key) =>
          productBox[key].name.toLowerCase() == event.name.toLowerCase());
      Product product;
      product = productBox[index];
      product.quantity = event.quantity + product.quantity;
      Hive.box("products").put(index, product);
    }
  }

  _findProductByScanner(event) {
    Map productBox = Hive.box('products').toMap();
    if (productBox.values.any((product) => product.barcode == event.barcode)) {
      var index = productBox.keys.firstWhere((key) =>
          productBox[key].barcode.replaceAll(" ", "").toLowerCase() ==
          event.barcode.replaceAll(" ", "").toLowerCase());
      return Hive.box("products").get(index);
    } else
      return Product('', 0, '', '', '', 0);
  }
}
