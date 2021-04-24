import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/model/products/products.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial());

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is LoadCategoriesEvent) {
      yield LoadedCategoryListState();
    } else if (event is GetSearchEvent) {
      yield LoadingCategoryListState();
      var categorysBox = Hive.box('categories');
      List listOfCategorysValues = List.empty();
      listOfCategorysValues = categorysBox.values
          .where((element) => element
              .toString()
              .toLowerCase()
              .replaceAll(" ", "")
              .contains(event.searchText.replaceAll(" ", "").toLowerCase()))
          .toList();

      yield LoadedCategoryListSearchState(listOfCategorysValues);
    } else if (event is AddCategoryEvent) {
      yield LoadingCategoryListState();
      var categorysBox = Hive.box('categories').toMap();
      if (categorysBox.values.any((element) =>
          element.toLowerCase().replaceAll(" ", "") ==
          event.categoryName.toLowerCase().replaceAll(" ", ""))) {
                    yield CategoryExsistsState();

      } else {
        _addCategory(event);
        yield LoadedCategoryListState();
      }
    } else if (event is EditCategoryEvent) {
      yield LoadingCategoryListState();
      _editCategory(event);
      yield LoadedCategoryListState();
    } else if (event is DeleteCategoryEvent) {
      yield LoadingCategoryListState();
      _deleteCateogry(event);
      yield LoadedCategoryListState();
    }
  }

  _editCategory(event) async {
    await Hive.openBox('products');

    Map products = Hive.box('products').toMap();
    products.keys
        .where((key) => products[key].category == event.editedCategory)
        .forEach((element) {
      Product temp = Hive.box('products').get(element);

      temp.category = event.newCategory;

      Hive.box('products').put(element, temp);
    });

    var categorysBox = Hive.box('categories').toMap();

    int indexcategory = categorysBox.keys
        .firstWhere((key) => categorysBox[key] == event.editedCategory);

    Hive.box('categories').put(indexcategory, event.newCategory);
    Hive.box("products").close();
  }

  _deleteCateogry(event) {
    var categorysBox = Hive.box('categories').toMap();
    var index = categorysBox.keys
        .firstWhere((key) => categorysBox[key] == event.categoryName);
    Hive.box('categories').delete(index);
  }

  _addCategory(event) {
    String name =
        event.categoryName[0].toUpperCase() + event.categoryName.substring(1);
    Hive.box('categories').add(name);
  }
}
