part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class LoadingOrderState extends OrderState {}

class ProdcutFindedState extends OrderState {
  final Product product;
  ProdcutFindedState(this.product);
}
class RefreshOrderState extends OrderState {}

class AddToBasketState extends OrderState {
  final Product tempProduct;
  AddToBasketState(this.tempProduct);
}
