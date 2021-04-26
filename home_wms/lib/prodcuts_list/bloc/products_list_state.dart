part of 'products_list_bloc.dart';

@immutable
abstract class ProductsListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialProdcutsListState extends ProductsListState {}

class LoadingProdcutsListState extends ProductsListState {}

class LoadedProdcutsListState extends ProductsListState {}

class LoadedProductsListSearchState extends ProductsListState {
 final List listOfObjects;
  LoadedProductsListSearchState(this.listOfObjects);
}

class ReturnToMenuProdcutsListState extends ProductsListState {}
