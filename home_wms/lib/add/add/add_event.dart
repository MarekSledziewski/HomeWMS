part of 'add_bloc.dart';

@immutable
abstract class AddEvent extends Equatable {}

class AddProductEvent extends AddEvent {
  final String productName;
  final String productCategory;
  final String productBarCode;
  final String productProducer;
  final double prodcutPrice;
  final int productQuantity;
  AddProductEvent(this.productName, this.productCategory, this.productBarCode,
      this.productProducer, this.prodcutPrice, this.productQuantity);

  @override
  List<Object?> get props => [productName, productQuantity];
}

class ReturnToMenuAddEvent extends AddEvent {
  @override
  List<Object?> get props => [];
}
