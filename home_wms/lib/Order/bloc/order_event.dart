part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
}

class FindByScanner extends OrderEvent {
  final String barcode;

  FindByScanner(this.barcode);

  @override
  List<Object?> get props => [barcode];
}

class RefreshOrderEvent extends OrderEvent {
  @override
  List<Object?> get props => [];
}

class AddToBasket extends OrderEvent {
  final Product product;
  final int quantity;
  final int quantityInList;

  AddToBasket(this.product, this.quantity, this.quantityInList);

  @override
  List<Object?> get props => [product];
}
