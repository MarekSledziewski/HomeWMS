import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/add/bloc/add_bloc.dart';
import 'package:home_wms/category/bloc/category_bloc.dart';
import 'package:home_wms/delete/bloc/delete_bloc.dart';
import 'package:home_wms/menu/ui/menu_screen.dart';
import 'package:home_wms/model/producer/producer.dart';
import 'package:home_wms/prodcuts_list/bloc/products_list_bloc.dart';
import 'package:home_wms/producer/bloc/producer_bloc.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'model/products/products.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ProducerAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildProviders();
  }

  Widget buildProviders() => MultiBlocProvider(providers: [
        BlocProvider<ProductsListBloc>(
          create: (BuildContext context) => ProductsListBloc(),
        ),
        BlocProvider<AddBloc>(
          create: (BuildContext context) => AddBloc(),
        ),
        BlocProvider<DeleteBloc>(
          create: (BuildContext context) => DeleteBloc(),
        ),
        BlocProvider<CategoryBloc>(
          create: (BuildContext context) => CategoryBloc(),
        ),
        BlocProvider<ProducerBloc>(
          create: (BuildContext context) => ProducerBloc(),
        ),
      ], child: MaterialApp(title: "HomeWMS", home: MenuScreen()));
}
