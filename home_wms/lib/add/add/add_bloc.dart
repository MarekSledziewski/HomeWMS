import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/model/item.dart';
import 'package:meta/meta.dart';

part 'add_event.dart';

part 'add_state.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  AddBloc() : super(InitialAddState());

  @override
  Stream<AddState> mapEventToState(AddEvent event) async* {
    if (event is AddItemEvent) {
      Hive.box('items').add(Item(event.itemName, event.itemQuantity));
      yield ProdcutAdded();
    }
  }
}
