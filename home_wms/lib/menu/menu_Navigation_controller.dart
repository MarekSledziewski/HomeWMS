import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/Order/ui/order_screen.dart';
import 'package:home_wms/add/ui/add_new_screen.dart';
import 'package:home_wms/add/ui/add_to_exsisting.dart';
import 'package:home_wms/category/ui/category_screen.dart';
import 'package:home_wms/loading_animation.dart';
import 'package:home_wms/menu/ui/add_menu_screen.dart';
import 'package:home_wms/options/ui/options_screen.dart';
import 'package:home_wms/prodcuts_list/ui/products_list_screen.dart';
import 'package:home_wms/producer/ui/producer_screen.dart';

class MenuNavigationController {

  navigate(_buttonName, context) {
    switch (_buttonName) {
      case "Add New":
        {
          return _animateToAddNew(context);
        }
      case "Add Exsisted":
        {
          return _animateToAddExsisted(context);
        }
      case "Add":
        {
          return _animateToMenuAdd(context);
        }
      case "Order":
        {
          return _animateToDelete(context);
        }
      case "Products":
        {
          return _animateToProductsList(context);
        }
      case "Producers":
        {
          return _animateToHistory(context);
        }
      case "Categories":
        {
          return _animateToCategories(context);
        }
           case "Options":
        {
          return _animateToOptions(context);
        }
    }
  }

  _animateToOptions(context) {
    return Navigator.push(
        context, new MaterialPageRoute(builder: (context) => OptionsScreen()));
  }

  _animateToAddNew(context) => Navigator.push(context,
      new MaterialPageRoute(builder: (context) => _buildHiveAddNewScreen()));

  _animateToAddExsisted(context) => Navigator.push(context,
      new MaterialPageRoute(builder: (context) => _buildHiveAddScreen()));

  _animateToMenuAdd(context) => Navigator.push(
      context, new MaterialPageRoute(builder: (context) => MenuAddScreen()));

  _animateToDelete(context) => Navigator.push(
      context, new MaterialPageRoute(builder: (context) => _buildHiveOrdercreen()));

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

Widget _buildHiveAddScreen() {
  return FutureBuilder(
      future: Hive.openBox('products'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return throw (snapshot.error.toString());
          } else {
            return AddToExsisting();
          }
        }
        return LoadingAnimation();
      });
}
Widget _buildHiveOrdercreen() {
  return FutureBuilder(
      future: Hive.openBox('products'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return throw (snapshot.error.toString());
          } else {
            return OrderScreen();
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

Widget _buildHiveAddNewScreen() => FutureBuilder(
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
