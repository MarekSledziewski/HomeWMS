import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_wms/menu/menu_navigation_controller.dart';

class MenuScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildButtons(context),
    );
  }

  final MenuNavigationController _navigationController =
      new MenuNavigationController();

  Widget buildButtons(context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton('Products', Colors.greenAccent, context),
          _buildButton('Options', Colors.yellowAccent, context),
          _buildButton('Delete', Colors.blueAccent, context),
          _buildButton('Add', Colors.redAccent, context),
          _buildButton('Producers', Colors.brown, context),
          _buildButton('Categories', Colors.purpleAccent, context),
        ],
      );

  Widget _buildButton(_buttonName, _buttonColor, context) => Container(
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
              splashColor: _buttonColor.withAlpha(90),
              highlightColor: _buttonColor.withAlpha(90),
              onTap: () {
                _navigationController.navigate(_buttonName, context);
              },
              child: Center(
                  child: Text(_buttonName,
                      style: GoogleFonts.lato(
                          fontSize:
                              MediaQuery.of(context).size.width * 0.07))))));
}
