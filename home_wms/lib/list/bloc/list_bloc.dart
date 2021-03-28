import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'list_event.dart';

part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(InitialListState());

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    // TODO: Add your event logic
  }
}
