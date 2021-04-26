part of 'add_bloc.dart';

@immutable
abstract class AddEvent extends Equatable {}

class AddProductEvent extends AddEvent {
  final Product product;
  AddProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class EditEvent extends AddEvent {
  @override
  List<Object?> get props => [];
}

class AddQuanitiEvent extends AddEvent {
   final int quantity;
     final String name;
  AddQuanitiEvent(this.quantity,this.name);
  @override
  List<Object?> get props => [quantity, name];
}
