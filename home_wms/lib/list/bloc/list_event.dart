part of 'list_bloc.dart';

@immutable
abstract class ListEvent extends Equatable {

}

class GetSearchEvent extends ListEvent {
  final String searchText;
  GetSearchEvent(this.searchText);

  @override
  List<Object> get props => [searchText];
}


class LoadItemsEvent extends ListEvent {
  @override
  List<Object> get props => [];
}
