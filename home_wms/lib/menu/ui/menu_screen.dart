import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_wms/menu/bloc/menu_bloc.dart';

import 'menu_button.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildBlocBuilder());
  }

  

 

  Widget buildBlocBuilder() => BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuStateInitial) {
            return buildButtons();
          } else {
            return Center(child: Text("Error try again later :("));
          }
        },
      );

  Widget buildButtons() => 
      Column(
 
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Expanded( child: Row(
          children: [
         MenuButtons('Products', Colors.greenAccent),
            MenuButtons('Options', Colors.yellowAccent),
          ],
        )),
         Expanded( child: Row(
          children: [
             MenuButtons('Delete', Colors.blueAccent),
            MenuButtons('Add', Colors.redAccent),],),),
            Expanded( child: Row(
          children: [
             MenuButtons('History', Colors.brown),
            MenuButtons('Categories', Colors.purpleAccent),
          ],),),
           
      ],
    );
  
}
