part of 'producer_bloc.dart';

abstract class ProducerState extends Equatable {
  const ProducerState();
  
  @override
  List<Object> get props => [];
}

class ProducerInitial extends ProducerState {}

class LoadingProducerListState extends ProducerState {}

class LoadedProducerListState extends ProducerState {}


// ignore: must_be_immutable
class LoadedProducerListSearchState extends ProducerState 
{  
  List listOfProducers;
  LoadedProducerListSearchState(this.listOfProducers);
  } 
  
  // ignore: must_be_immutable
  class ProducerExsistsState extends ProducerState{
Producer producer;
    ProducerExsistsState(this.producer);
  }
  