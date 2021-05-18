import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/model/products/products.dart';
import 'package:meta/meta.dart';

part 'products_list_event.dart';

part 'products_list_state.dart';

class ProductsListBloc extends Bloc<ProdcutsListEvent, ProductsListState> {
  ProductsListBloc() : super(InitialProdcutsListState());

  @override
  Stream<ProductsListState> mapEventToState(ProdcutsListEvent event) async* {
    if (event is LoadProductsEvent) {
      yield LoadedProdcutsListState();
    } else if (event is GetSearchEvent) {
      yield LoadingProdcutsListState();
      List<Product> productBoxList =
          Hive.box('products').values.cast<Product>().toList();
      List<Product> listOfProductsValues = List.empty();

      listOfProductsValues += productBoxList
          .where((element) => element.name
              .toLowerCase()
              .replaceAll(" ", "")
              .contains(event.searchText.toLowerCase().replaceAll(" ", "")))
          .toList();
      productBoxList.removeWhere((element) => element.name
          .toLowerCase()
          .replaceAll(" ", "")
          .contains(event.searchText.toLowerCase().replaceAll(" ", "")));

      listOfProductsValues += productBoxList
          .where((element) => element.category
              .toLowerCase()
              .replaceAll(" ", "")
              .contains(event.searchText.toLowerCase().replaceAll(" ", "")))
          .toList();
      productBoxList.removeWhere((element) => element.category
          .toLowerCase()
          .replaceAll(" ", "")
          .contains(event.searchText.toLowerCase().replaceAll(" ", "")));
        listOfProductsValues += productBoxList
          .where((element) => element.producer
              .toLowerCase()
              .replaceAll(" ", "")
              .contains(event.searchText.toLowerCase().replaceAll(" ", "")))
          .toList();
      productBoxList.removeWhere((element) => element.producer
          .toLowerCase()
          .replaceAll(" ", "")
          .contains(event.searchText.toLowerCase().replaceAll(" ", "")));

      yield LoadedProductsListSearchState(listOfProductsValues);
    } else if (event is EditProductEvent) {
      yield LoadingProdcutsListState();
      Map productBox = Hive.box('products').toMap();

      var index = productBox.keys.firstWhere((key) =>
          productBox[key].name.replaceAll(" ", "").toLowerCase() ==
          event.oldProduct.name.replaceAll(" ", "").toLowerCase());
      Hive.box("products").put(index, event.product);
      yield LoadedProdcutsListState();
    }
  }
}
