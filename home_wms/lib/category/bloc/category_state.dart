part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
  
  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class LoadingCategoryListState extends CategoryState {}

class LoadedCategoryListState extends CategoryState {}


// ignore: must_be_immutable
class LoadedCategoryListSearchState extends CategoryState 
{  
  List listOfCategories;
  LoadedCategoryListSearchState(this.listOfCategories);
  }
  class CategoryExsistsState extends CategoryState{}