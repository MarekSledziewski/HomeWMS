import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  Widget buildBlocBuilder() =>BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuStateInitial) {
            return buildButtons();
          }  else {
            return Center(child: Text("Error try again later :("));
          }
        },
      );

  Widget buildButtons() {
    return Center(
      child: Transform.rotate(
        origin: Offset(0, 0),
        angle: -(pi / 180 * 45),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / sqrt2,
          height: MediaQuery.of(context).size.width / sqrt2,
          child: Stack(
            children: [
              Align(
                alignment: Alignment(-0.8, -0.8),
                child: MenuButtons(
                  'Delete',
                  Colors.blueAccent,
                ),
              ),
              Align(
                alignment: Alignment(0.8, -0.8),
                child: MenuButtons('List', Colors.greenAccent),
              ),
              Align(
                alignment: Alignment(0.8, 0.8),
                child: MenuButtons('Add', Colors.redAccent),
              ),
              Align(
                alignment: Alignment(-0.8, 0.8),
                child: MenuButtons('Options', Colors.yellowAccent),
              )
            ],
          ),
        ),
      ),
    );
  }
   
}
