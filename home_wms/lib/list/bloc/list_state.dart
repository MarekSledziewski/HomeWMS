part of 'list_bloc.dart';

@immutable
abstract class ListState extends Equatable
{
  @override

  List<Object?> get props => [];
}

class InitialListState extends ListState {}
class LoadingListState extends ListState {}
class LoadedListState extends ListState {}
