part of 'add_bloc.dart';

@immutable
abstract class AddEvent extends Equatable {}

class AddProductEvent extends AddEvent {
  final Product product;

  AddProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class RefreshAddEvent extends AddEvent {
  @override
  List<Object?> get props => [];
}


class EditEvent extends AddEvent {
  @override
  List<Object?> get props => [];
}

class AddQuanitiEvent extends AddEvent {
  final int quantity;
  final String name;

  AddQuanitiEvent(this.quantity, this.name);

  @override
  List<Object?> get props => [quantity, name];
}

class FindByScanner extends AddEvent {
  final String barcode;

  FindByScanner(this.barcode);

  @override
  List<Object?> get props => [barcode];
}
