part of 'products_list_bloc.dart';

@immutable
abstract class ProdcutsListEvent extends Equatable {}

class GetSearchEvent extends ProdcutsListEvent {
  final String searchText;

  GetSearchEvent(this.searchText);

  @override
  List<Object> get props => [searchText];
}

class LoadProductsEvent extends ProdcutsListEvent {
  @override
  List<Object> get props => [];
}

class EditProductEvent extends ProdcutsListEvent {
  final Product oldProduct;
  final Product product;

  EditProductEvent(this.oldProduct, this.product);

  @override
  List<Object> get props => [];
}
