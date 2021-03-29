import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/add/add/add_bloc.dart';
import 'package:home_wms/list/bloc/list_bloc.dart';
import 'package:home_wms/page_controller.dart';
import 'menu/bloc/menu_bloc.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
  await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildProviders();
  }

  Widget buildProviders() => MultiBlocProvider(providers: [
        BlocProvider<MenuBloc>(
          create: (BuildContext context) => MenuBloc(),
        ),
        BlocProvider<ListBloc>(
          create: (BuildContext context) => ListBloc(),
        ),
         BlocProvider<AddBloc>(
          create: (BuildContext context) => AddBloc(),
        ),
      ], child: MaterialApp(title: "HomeWMS", home: PageViewController()));


}
