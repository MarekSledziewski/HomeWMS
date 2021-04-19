part of 'add_bloc.dart';

@immutable
abstract class AddState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialAddState extends AddState {}

class ProdcutAdded extends AddState {}

class ReturnToMenuAddState extends AddState {

}
