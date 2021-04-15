import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'delete_event.dart';

part 'delete_state.dart';

class DeleteBloc extends Bloc<DeleteEvent, DeleteState> {
  DeleteBloc() : super(InitialDeleteState());

  @override
  Stream<DeleteState> mapEventToState(DeleteEvent event) async* {
    // TODO: Add your event logic
  }
}
