import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/model/producer/producer.dart';
import 'package:home_wms/model/products/products.dart';

part 'producer_event.dart';

part 'producer_state.dart';

class ProducerBloc extends Bloc<ProducerEvent, ProducerState> {
  ProducerBloc() : super(ProducerInitial());

  @override
  Stream<ProducerState> mapEventToState(ProducerEvent event,) async* {
    if (event is LoadProducersEvent) {
      yield LoadedProducerListState();
    } else if (event is GetSearchEvent) {
      yield LoadingProducerListState();
      yield LoadedProducerListSearchState(_searchProducer(event));
    } else if (event is AddProducerEvent) {
      yield LoadingProducerListState();
      if (!_producerExsists(event)) {
        _addProducer(event);
        yield LoadedProducerListState();
      } else {
        yield ProducerExsistsState(Producer(
            event.producerName, event.producerAdress,
            event.producerDescryption));
      }
    } else if (event is EditproducerEvent) {
      yield LoadingProducerListState();

      if (!_producerExsists(event)) {
        _editproducer(event);
        yield LoadedProducerListState();
      } else {
        yield ProducerExsistsState(Producer(
            event.producerName, event.producerAdress,
            event.producerDescryption));
      }
    } else if (event is DeleteProducerEvent) {
      yield LoadingProducerListState();
      if (_producerExsists(event)) {
        _deleteproducer(event);
        yield LoadedProducerListState();
      }
    }
  }

  _editproducer(event) async {
    await Hive.openBox('products');

    Map products = Hive.box('products').toMap();

    products.keys
        .where((key) => products[key].producer == event.oldproducer.name)
        .forEach((element) {
      Product temp = Hive.box('products').get(element);

      temp.producer = event.producerName;

      Hive.box('products').put(element, temp);
    });

    var producersBox = Hive.box('producers').toMap();

    int indexProducers = producersBox.keys
        .firstWhere((key) => producersBox[key].name == event.oldproducer.name);

    String name =
        event.producerName[0].toUpperCase() + event.producerName.substring(1);

    Hive.box('producers').put(indexProducers,
        Producer(name, event.producerAdress, event.producerDescryption));

    Hive.box("products").close();
  }

  _deleteproducer(event) {
    var producersBox = Hive.box('producers').toMap();
    var index = producersBox.keys
        .firstWhere((key) => producersBox[key].name == event.producerName);
    Hive.box('producers').delete(index);
  }

  _addProducer(event) {
    String name =
        event.producerName[0].toUpperCase() + event.producerName.substring(1);
    Hive.box('producers')
        .add(Producer(name, event.producerAdress, event.producerDescryption));
  }

  _searchProducer(event) {
    var producersBox = Hive.box('producers');
    List listOfProducersValues = List.empty();
    listOfProducersValues = producersBox.values
        .where((element) =>
        element
            .toString()
            .toLowerCase()
            .replaceAll(" ", "")
            .contains(event.searchText.replaceAll(" ", "").toLowerCase()))
        .toList();
    return listOfProducersValues;
  }

  _producerExsists(event) {
    return Hive
        .box('producers')
        .values
        .any((element) =>
    element.name.toString().toLowerCase().replaceAll('', ' ') ==
        event.producerName.toString().toLowerCase().replaceAll('', ' '));
  }
}
