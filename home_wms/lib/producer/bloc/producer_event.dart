part of 'producer_bloc.dart';

abstract class ProducerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadProducersEvent extends ProducerEvent {}

class GetSearchEvent extends ProducerEvent {
  final String searchText;

  GetSearchEvent(this.searchText);
}

class AddProducerEvent extends ProducerEvent {
  final String producerName;
  final String producerAdress;
  final String producerDescryption;

  AddProducerEvent(this.producerName, this.producerAdress,
      this.producerDescryption);
}

class DeleteProducerEvent extends ProducerEvent {
  final String producerName;

  DeleteProducerEvent(this.producerName);
}

class EditproducerEvent extends ProducerEvent {
  final Producer oldproducer;
  final String producerName;
  final String producerAdress;
  final String producerDescryption;

  EditproducerEvent(this.oldproducer,
      this.producerName, this.producerAdress, this.producerDescryption);
}
