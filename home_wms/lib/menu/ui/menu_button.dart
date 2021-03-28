import 'dart:math';
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
  late double _screenWidth = MediaQuery.of(context).size.width;

  MenuButtonsState(
    this._buttonName,
    this._buttonColor,
  );

  _buttonAction() {
    BlocProvider.of<MenuBloc>(context).add(ButtonEvent(_buttonName));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 4)),
        ],
      ),
      width: _screenWidth / sqrt2 * 0.5 - 20,
      height: _screenWidth / sqrt2 * 0.5 - 20,
      duration: const Duration(seconds: 2),
      curve: Curves.easeInCubic,
      child: Material(
        color: _buttonColor,
        child: InkWell(
          radius: 40,
          splashColor: _buttonColor.withAlpha(100),
          highlightColor: Colors.grey,
          onTap: () {
            _buttonAction();
          },
          child: Transform.rotate(
              angle: pi / 180 * 45,
              child: Center(
                child: Text(
                  _buttonName,
                  style: GoogleFonts.lato(
                      fontSize: MediaQuery.of(context).size.width * 0.07),
                ),
              )),
        ),
      ),
    );
  }
}
