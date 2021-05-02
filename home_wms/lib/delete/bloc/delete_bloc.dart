import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../../model/products/products.dart';

part 'delete_event.dart';

part 'delete_state.dart';

class DeleteBloc extends Bloc<DeleteEvent, DeleteState> {
  DeleteBloc() : super(InitialDeleteState());

  @override
  Stream<DeleteState> mapEventToState(DeleteEvent event) async* {
    if (event is DeleteProductEvent) {
      var productBox = Hive.box('products');
      late Product tempInstanceOfProduct;
      var listOfProductsValues =
      productBox.values.where((element) =>
      element.name.replaceAll(" ", "")
          .toLowerCase() ==
          event.productName.replaceAll(" ", "").toLowerCase());
      if (listOfProductsValues.isNotEmpty) {
        listOfProductsValues.forEach(
                (element) =>
            {
              tempInstanceOfProduct = element,
              tempInstanceOfProduct.quantity -= event.productQuantity
            });
      }
      else {
        yield NoSuchProductState();
      }
      yield ProdcutDeleted();
    } else if (event is ReturnToMenuDeletedEvent) {
      yield ReturnToMenuDeleteState();
      yield InitialDeleteState();
    }
  }
}
