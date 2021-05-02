part of 'delete_bloc.dart';

@immutable
abstract class DeleteEvent {}

class DeleteProductEvent extends DeleteEvent {
  final String productName;
  final int productQuantity;

  DeleteProductEvent(this.productName, this.productQuantity);


  List<Object?> get props => [productName, productQuantity];
}

class ReturnToMenuDeletedEvent extends DeleteEvent {

  List<Object?> get props => [];
}
