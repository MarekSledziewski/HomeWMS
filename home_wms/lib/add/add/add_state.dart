part of 'add_bloc.dart';

@immutable
abstract class AddState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialAddState extends AddState {}

class ScannInputState extends AddState {}

class ProdcutAdded extends AddState {}
