part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
  
  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class LoadingCategoryListState extends CategoryState {}

class LoadedCategoryListState extends CategoryState {}


class LoadedCategoryListSearchState extends CategoryState 
{  
  final List listOfCategories;
  LoadedCategoryListSearchState(this.listOfCategories);
  }
  class CategoryExsistsState extends CategoryState{}