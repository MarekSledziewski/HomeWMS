import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/add/ui/add_new_screen.dart';
import 'package:home_wms/delete/ui/delete_screen.dart';
import 'package:home_wms/loading_animation.dart';
import 'package:home_wms/menu/ui/menu_screen.dart';
import 'package:home_wms/options/ui/options_screen.dart';
import 'package:home_wms/prodcuts_list/ui/products_list_screen.dart';
import 'package:home_wms/producer/ui/producer_screen.dart';


import 'Category/ui/category_screen.dart';
import 'menu/bloc/menu_bloc.dart';

class PageViewController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PageViewControllerState();
}

class PageViewControllerState extends State<PageViewController> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBlocListeners();
  }

  Widget _buildBlocListeners() => MultiBlocListener(
        listeners: [
          BlocListener<MenuBloc, MenuState>(
            listener: (context, state) {
              if (state is MenuButtonActionNavigator) {
                switch (state.buttonName) {
                  case "Add":
                    {
                      return _animateToAdd();
                    }
                  case "Delete":
                    {
                      return _animateToDelete();
                    }
                  case "Products":
                    {
                      return _animateToProductsList();
                    }
                  case "Options":
                    {
                      return _animateToOptions();
                    }
                  case "Producers":
                    {
                      return _animateToHistory();
                    }
                  case "Categories":
                    {
                      return _animateToCategories();
                    }
                }
              }
            },
          ),
        ],
        child: MenuScreen(),
      );

  _animateToAdd() => Navigator.push(
      context, new MaterialPageRoute(builder: (context) => _addScreen()));

  _animateToDelete() => Navigator.push(
      context, new MaterialPageRoute(builder: (context) => DeleteScreen()));

  _animateToOptions() => Navigator.push(
      context, new MaterialPageRoute(builder: (context) => OptionsScreen()));

  _animateToProductsList() => Navigator.push(context,
      new MaterialPageRoute(builder: (context) => _buildHiveProductsList()));

  _animateToCategories() => Navigator.push(context,
      new MaterialPageRoute(builder: (context) => _buildHiveCategories()));

  _animateToHistory() => Navigator.push(context,
      new MaterialPageRoute(builder: (context) => _buildHiveProducers()));
}

Widget _buildHiveProductsList() {
  return FutureBuilder(
      future: Hive.openBox('products'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return throw (snapshot.error.toString());
          } else {
            return ProductsListScreen();
          }
        }
        return LoadingAnimation();
      });
}

Widget _buildHiveCategories() {
  return FutureBuilder(
      future: Hive.openBox('categories'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return throw (snapshot.error.toString());
          } else {
            return CategoryScreen();
          }
        }
        return LoadingAnimation();
      });
}
  Widget _addScreen() {
    return FutureBuilder(
        future: Hive.openBox('categories'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return throw (snapshot.error.toString());
            } else {
              return FutureBuilder(
        future: Hive.openBox('producers'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return throw (snapshot.error.toString());
            } else {
              return AddScreen();
            }
          }
          return LoadingAnimation();
        });;
            }
          }
          return LoadingAnimation();
        });
  }
Widget _buildHiveProducers() {
  return FutureBuilder(
      future: Hive.openBox('producers'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return throw (snapshot.error.toString());
          } else {
            return ProducerScreen();
          }
        }
        return LoadingAnimation();
      });
}
