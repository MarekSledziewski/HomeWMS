part of 'add_bloc.dart';

@immutable
abstract class AddState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialAddState extends AddState {}

class ProductAddingState extends AddState {}

class ProdcutAddedSimilarState extends AddState {
}
class ProdcutAddedState extends AddState {
}

class ProductExsistsState extends AddState {
  final Product product;
  ProductExsistsState(this.product);
}
class ProdcutFindedState extends AddState {
  final Product product;
  ProdcutFindedState(this.product);
}
