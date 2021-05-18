import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_wms/menu/menu_navigation_controller.dart';

class MenuAddScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildButtons(context),
    );
  }


  Widget buildButtons(context) =>  Column(

        children: [
          _buildButton('Add New',Icon( Icons.add_to_queue  , color: Colors.red, ), context),
          _buildButton('Add Exsisted',Icon( Icons.add, color: Colors.redAccent, ), context),
        ],
      );


  Widget _buildButton(String _buttonName, Icon _buttonIcon, context) => Expanded( child: Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 0.1,
              offset: Offset(0, 1)),
        ],
      ),
      child: Material(
          child: InkWell(
              radius: 100,
              splashColor: Colors.grey,
              onTap: () {
                MenuNavigationController().navigate(_buttonName, context);
              },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    _buttonIcon,
                    Text('  '+_buttonName,
                      style: GoogleFonts.lato(
                          fontSize:
                              MediaQuery.of(context).size.width * 0.07))])))));
}
