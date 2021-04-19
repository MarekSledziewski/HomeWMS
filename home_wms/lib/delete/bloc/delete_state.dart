part of 'delete_bloc.dart';

@immutable
abstract class DeleteState {}

class InitialDeleteState extends DeleteState {}

class ScanInputState extends DeleteState {}

class ProdcutDeleted extends DeleteState {}
class NoSuchProductState extends DeleteState {}

class ReturnToMenuDeleteState extends DeleteState {

}
