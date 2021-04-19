import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

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
      String name = event.categoryName[0].toUpperCase() + event.categoryName.substring(1);
      Hive.box('categories').add(name);

      yield LoadedCategoryListState();


    } else if (event is DeleteCategoryEvent) {
      yield LoadingCategoryListState();
      var categorysBox = Hive.box('categories').toMap();
      var index = categorysBox.keys
          .firstWhere((k) => categorysBox [k] == event.categoryName);
      Hive.box('categories').delete(index);
      yield LoadedCategoryListState();
    }
  }
}
