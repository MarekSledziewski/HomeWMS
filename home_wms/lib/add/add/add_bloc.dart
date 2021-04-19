import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/model/category/category.dart';
import 'package:home_wms/model/producent/producer.dart';
import 'package:home_wms/model/products/products.dart';
import 'package:meta/meta.dart';

part 'add_event.dart';

part 'add_state.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  AddBloc() : super(InitialAddState());

  @override
  Stream<AddState> mapEventToState(AddEvent event) async* {
    if (event is AddProductEvent) {
      await Hive.openBox('products');
      await Hive.openBox('producer');
      await Hive.openBox('categories');

      late Product tempInstanceOfProduct;

      var productBox = Hive.box('products');

      var listOfProductsValues = productBox.values.where((element) =>
          element.name.replaceAll(" ", "").toLowerCase() ==
          event.productName.replaceAll(" ", "").toLowerCase());

      if (listOfProductsValues.isNotEmpty) {
        listOfProductsValues.forEach((element) => {
              tempInstanceOfProduct = element,
              tempInstanceOfProduct.quantity += event.productQuantity
            });
      } else {
        String name = event.productName[0].toUpperCase() + event.productName.substring(1);
       

       
        productBox.add(Product(
            name,
            event.productQuantity,
            event.productBarCode,
            event.productCategory,
            event.productProducer,
            event.prodcutPrice)); 
      }
      Hive.box('products').close();
      Hive.box('producer').close();
      Hive.box('categories').close();
    }

    if (event is ReturnToMenuAddEvent) {
      yield ReturnToMenuAddState();
      yield InitialAddState();
    }
  }
}
