import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OptionsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>OptionsScreenState();
}
class OptionsScreenState extends State<OptionsScreen>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Container(width: 200,
      height: 200, color: Colors.yellowAccent,)));
  }}