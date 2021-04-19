import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/Category/bloc/category_bloc.dart';
import 'package:home_wms/loading_animation.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  final searchTextFieldController = TextEditingController();
  final _addTextFieldController = TextEditingController();

  final categoriesBox = Hive.box('categories');

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategoryBloc>(context).add(LoadCategoriesEvent());
  }

  @override
  void dispose() {
    categoriesBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(),
        body: Column(children: [
          _searchField(),
          _buildBlocBuilder(),
          Align(
            alignment: Alignment.bottomRight,
            child: _addCategoryButton(),
          )
        ]));
  }

  AppBar _buildAppbar() => AppBar(
        title: (Text("Categories")),
        backgroundColor: Colors.amber,
        centerTitle: true,
      );

  Widget _buildBlocBuilder() =>
      BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
        if (state is LoadingCategoryListState) {
          return LoadingAnimation();
        } else if (state is LoadedCategoryListSearchState) {
          return __buildCategoryListSearched(state.listOfCategories);
        } else {
          return _buildCategoryList();
        }
      });

  Widget _buildCategoryList() {
    return Expanded(
        child: ListView.builder(
            itemCount: categoriesBox.length,
            itemBuilder: (context, index) {
              final category = categoriesBox.getAt(index);
              return _listTile(category);
            }));
  }

  Widget __buildCategoryListSearched(List listOfCategories) {
    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, index) => _listTile(listOfCategories[index]),
      itemCount: listOfCategories.length,
    ));
  }

  Widget _listTile(category) => Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1)),
              ],
            ),
            child: ListTile(
                minVerticalPadding: 2,
                title: Text(
                  category,
                  textAlign: TextAlign.center,
                )),
          ),
          actions: <Widget>[
            IconSlideAction(
                caption: 'Delete',
                color: Colors.blue,
                icon: Icons.delete,
                onTap: () => {
                      print(category),
                      _deleteCategory(category),
                    })
          ]);

  Widget _searchField() => TextField(
      onEditingComplete: () {
        _getSearch();
        FocusScope.of(context).unfocus();
      },
      textInputAction: TextInputAction.next,
      maxLength: 50,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: searchTextFieldController,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          filled: true,
          counter: Offstage(),
          fillColor: Colors.white,
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search),
          hintText: 'Search'));

  _getSearch() => BlocProvider.of<CategoryBloc>(context)
      .add(GetSearchEvent(searchTextFieldController.text));

  Widget _addCategoryButton() => FloatingActionButton(
      backgroundColor: Colors.redAccent,
      hoverColor: Colors.redAccent,
      splashColor: Colors.redAccent,
      onPressed: () => {
            _addDialog(),
          },
      child: Icon(
        Icons.add,
      ));

  _deleteCategory(category) {
    BlocProvider.of<CategoryBloc>(context).add(DeleteCategoryEvent(category));
  }

  _addDialog() => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Category'),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            Spacer(),
            OutlinedButton(
              onPressed: () {
                if (_addTextFieldController.text.isNotEmpty) {
                  BlocProvider.of<CategoryBloc>(context)
                      .add(AddCategoryEvent(_addTextFieldController.text));
                  Navigator.pop(context);
                  _addTextFieldController.clear();
                }
              },
              child: Text('Add'),
            ),
          ],
          content: TextField(
            controller: _addTextFieldController,
            decoration: InputDecoration(hintText: "Category"),
          ),
        );
      });
}
