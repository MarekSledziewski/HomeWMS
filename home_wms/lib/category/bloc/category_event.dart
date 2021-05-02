part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategoriesEvent extends CategoryEvent {}

class GetSearchEvent extends CategoryEvent {
  final String searchText;

  GetSearchEvent(this.searchText);
}

class AddCategoryEvent extends CategoryEvent {
  final String categoryName;

  AddCategoryEvent(this.categoryName);
}

class DeleteCategoryEvent extends CategoryEvent {
  final String categoryName;

  DeleteCategoryEvent(this.categoryName);
}

class EditCategoryEvent extends CategoryEvent {
  final String editedCategory;
  final String newCategory;

  EditCategoryEvent(this.editedCategory, this.newCategory);
}
