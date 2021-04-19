import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_wms/menu/bloc/menu_bloc.dart';

class MenuButtons extends StatefulWidget {
  late final String _buttonName;
  late final Color _buttonColor;

  MenuButtons(
    this._buttonName,
    this._buttonColor,
  );

  @override
  State<StatefulWidget> createState() =>
      MenuButtonsState(_buttonName, _buttonColor);
}

class MenuButtonsState extends State<MenuButtons> {
  late final String _buttonName;
  late final Color _buttonColor;
  MenuButtonsState(
    this._buttonName,
    this._buttonColor,
  );

  _buttonAction() {
    BlocProvider.of<MenuBloc>(context).add(ButtonEvent(_buttonName));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 4)),
                    ],
                  ),
                  child: Material(
                      color: _buttonColor,
                      child: InkWell(
                          radius: 100,
                          splashColor:
                              _buttonColor.withAlpha(90),
                          highlightColor: _buttonColor.withAlpha(90),
                          onTap: () {
                            _buttonAction();
                          },
                          child: Center(
                              child: Text(_buttonName,
                                  style: GoogleFonts.lato(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.07)))))));
            }
  }

