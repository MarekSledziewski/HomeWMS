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
          _buildButton('Products', Icons.list_sharp , context),
          _buildButton('Options', Icons.build_outlined  , context),
          _buildButton('Delete', Icons.delete , context),
          _buildButton('Add New', Icons.add_to_queue_sharp , context),
           _buildButton('Add', Icons.add_circle_outline_sharp  , context),
          _buildButton('Producers',Icons.category , context),
          _buildButton('Categories', Icons.business_center_outlined   , context),
        ],
      );

  Widget _buildButton(String _buttonName, _buttonIcon, context) => Container(
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
          child: InkWell(
              radius: 100,
              splashColor: Colors.grey,
              onTap: () {
                _navigationController.navigate(_buttonName, context);
              },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Icon(_buttonIcon),
                    Text('  '+_buttonName,
                      style: GoogleFonts.lato(
                          fontSize:
                              MediaQuery.of(context).size.width * 0.07))]))));
}
