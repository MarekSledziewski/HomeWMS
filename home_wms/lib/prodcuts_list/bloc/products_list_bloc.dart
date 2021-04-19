import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'products_list_event.dart';

part 'products_list_state.dart';

class ProductsListBloc extends Bloc<ProdcutsListEvent, ProductsListState> {
  ProductsListBloc() : super(InitialProdcutsListState());

  @override
  Stream<ProductsListState> mapEventToState(ProdcutsListEvent event) async* {
  
  if (event is LoadProductsEvent) {
      yield LoadedProdcutsListState();
    }

   else if (event is GetSearchEvent) {
      yield LoadingProdcutsListState();
      var productBox = Hive.box('products');
      List listOfProductsValues = List.empty();
      listOfProductsValues += productBox.values
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .replaceAll(" ", "")
              .contains(event.searchText.replaceAll(" ", "").toLowerCase()))
          .toList();
      listOfProductsValues += productBox.values
          .where((element) => element.category.name
              .toString()
              .toLowerCase()
              .replaceAll(" ", "")
              .contains(event.searchText.replaceAll(" ", "").toLowerCase()))
          .toList();
      listOfProductsValues += productBox.values
          .where((element) => element.producent
              .toString()
              .toLowerCase()
              .replaceAll(" ", "")
              .contains(event.searchText.replaceAll(" ", "").toLowerCase()))
          .toList();

      yield LoadedProductsListSearchState(listOfProductsValues);
    }
  }
}
