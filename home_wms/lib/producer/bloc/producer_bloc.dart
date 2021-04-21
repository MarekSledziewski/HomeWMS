import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/model/producer/producer.dart';

part 'producer_event.dart';
part 'producer_state.dart';

class ProducerBloc extends Bloc<ProducerEvent, ProducerState> {
  ProducerBloc() : super(ProducerInitial());

  @override
  Stream<ProducerState> mapEventToState(
    ProducerEvent event,
  ) async* {
    if (event is LoadProducersEvent) {
      yield LoadedProducerListState();
    } else if (event is GetSearchEvent) {
      yield LoadingProducerListState();
      var producersBox = Hive.box('producers');
      List listOfProducersValues = List.empty();
      listOfProducersValues = producersBox.values
          .where((element) => element
              .toString()
              .toLowerCase()
              .replaceAll(" ", "")
              .contains(event.searchText.replaceAll(" ", "").toLowerCase()))
          .toList();

      yield LoadedProducerListSearchState(listOfProducersValues);

    } else if (event is AddProducerEvent) {
      yield LoadingProducerListState();
      String name = event.producerName[0].toUpperCase() + event.producerName.substring(1);
      Hive.box('producers').add(Producer(name, event.producerAdress, event.producerDescryption));

      yield LoadedProducerListState();


    } else if (event is DeleteProducerEvent) {
      yield LoadingProducerListState();
      var producersBox = Hive.box('producers').toMap();
      var index = producersBox.keys
          .firstWhere((k) => producersBox [k] == event.producerName);
      Hive.box('producers').delete(index);
      yield LoadedProducerListState();
    }
  }
}
