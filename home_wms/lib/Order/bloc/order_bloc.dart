import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/model/products/products.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial());

  @override
  Stream<OrderState> mapEventToState(
    OrderEvent event,
  ) async* {
    if (event is FindByScanner) {
      yield LoadingOrderState();
      yield ProdcutFindedState(_findProductByScanner(event));
    } else if (event is RefreshOrderEvent) {
      yield LoadingOrderState();
      yield RefreshOrderState();
    } else if (event is AddToBasket) {
      if (event.quantity + event.quantityInList <= event.product.quantity) {
        yield LoadingOrderState();
        yield AddToBasketState(Product(
          event.product.name,
          event.quantity + event.quantityInList,
          event.product.barcode,
          event.product.name,
          event.product.producer,
          event.product.price,
        ));
      }
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
