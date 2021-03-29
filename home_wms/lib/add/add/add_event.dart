part of 'add_bloc.dart';

@immutable
abstract class AddEvent extends Equatable {}

class AddItemEvent extends AddEvent {
  final String itemName;
  final int itemQuantity;
  AddItemEvent(this.itemName, this.itemQuantity);

  @override
  List<Object?> get props => [itemName, itemQuantity];
}
