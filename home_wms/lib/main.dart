import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_wms/list/bloc/list_bloc.dart';
import 'package:home_wms/page_controller.dart';
import 'menu/bloc/menu_bloc.dart';

void main() {

    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildProvicers();
  }

  Widget buildProvicers() => MultiBlocProvider(providers: [
        BlocProvider<MenuBloc>(
          create: (BuildContext context) => MenuBloc(),
        ),
        BlocProvider<ListBloc>(
          create: (BuildContext context) => ListBloc(),
        ),
      ], child: MaterialApp(title: "HomeWMS", home: PageViewController()));
}
