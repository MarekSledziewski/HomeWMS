import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/add/ui/add_new_screen.dart';
import 'package:home_wms/category/ui/category_screen.dart';
import 'package:home_wms/delete/ui/delete_screen.dart';
import 'package:home_wms/loading_animation.dart';
import 'package:home_wms/options/ui/options_screen.dart';
import 'package:home_wms/prodcuts_list/ui/products_list_screen.dart';
import 'package:home_wms/producer/ui/producer_screen.dart';


class MenuNavigationController   {


  navigate(_buttonName, context){
                switch (_buttonName) {
                  case "Add":
                    {
                      return _animateToAdd(context);
                    }
                  case "Delete":
                    {
                      return _animateToDelete(context);
                    }
                  case "Products":
                    {
                      return _animateToProductsList(context);
                    }
                  case "Options":
                    {
                      return _animateToOptions(context);
                    }
                  case "Producers":
                    {
                      return _animateToHistory(context);
                    }
                  case "Categories":
                    {
                      return _animateToCategories(context);
                    }
                }
              }
      

  _animateToAdd(context) => Navigator.push(
      context, new MaterialPageRoute(builder: (context) => _addScreen()));

  _animateToDelete(context) => Navigator.push(
      context, new MaterialPageRoute(builder: (context) => DeleteScreen()));

  _animateToOptions(context) => Navigator.push(
      context, new MaterialPageRoute(builder: (context) => OptionsScreen()));

  _animateToProductsList(context) => Navigator.push(context,
      new MaterialPageRoute(builder: (context) => _buildHiveProductsList()));

  _animateToCategories(context) => Navigator.push(context,
      new MaterialPageRoute(builder: (context) => _buildHiveCategories()));

  _animateToHistory(context) => Navigator.push(context,
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
        });
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
