part of 'producer_bloc.dart';

abstract class ProducerState extends Equatable {
  const ProducerState();

  @override
  List<Object> get props => [];
}

class ProducerInitial extends ProducerState {}

class LoadingProducerListState extends ProducerState {}

class LoadedProducerListState extends ProducerState {}


class LoadedProducerListSearchState extends ProducerState {
  final List listOfProducers;

  LoadedProducerListSearchState(this.listOfProducers);
}

class ProducerExsistsState extends ProducerState {
  final Producer producer;

  ProducerExsistsState(this.producer);
}
  