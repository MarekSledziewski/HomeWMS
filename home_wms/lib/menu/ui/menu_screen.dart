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


  Widget buildButtons(context) =>  Column(
    
          children: [
             Expanded(child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children:[
               Text("HomeWMS", textAlign: TextAlign.center, style: GoogleFonts.lato(
                          fontSize:
                              MediaQuery.of(context).size.width * 0.07)),
               IconButton(padding: EdgeInsets.all(30), icon: Icon(Icons.miscellaneous_services, size: 50, ) , onPressed:()=>  MenuNavigationController().navigate('Options', context)),
                ])),
                   _buildButton('Products',Icon( Icons.list_sharp, color: Colors.green,) , context),
          _buildButton('Order', Icon(Icons.request_page, color: Colors.blueAccent,), context),
           _buildButton('Add', Icon(Icons.add_circle_outline_sharp, color: Colors.red ) , context),
          _buildButton('Producers',Icon(Icons.category, color: Colors.yellow ), context),
          _buildButton('Categories', Icon(Icons.business_center_outlined , color: Colors.amber)  , context),
        ],
      );

  Widget _buildButton(String _buttonName, Icon _buttonIcon, context) => Expanded(child: Container(
      padding: EdgeInsets.only(top:10, bottom: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1)),
        ],
      ),
      
      child: Material(
          child: InkWell(
              splashColor: Colors.grey,
              onTap: () {
                MenuNavigationController().navigate(_buttonName, context);
              },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    _buttonIcon
                    ,
                    Text('  '+_buttonName,
                      style: GoogleFonts.lato(
                          fontSize:
                              MediaQuery.of(context).size.width * 0.07))])))));
}
