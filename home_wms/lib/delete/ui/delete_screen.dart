import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>DeleteScreenState();
}
class DeleteScreenState extends State<DeleteScreen>
{
  @override
  Widget build(BuildContext context) {
  return Scaffold(body:Center(child: Container( width: 200,
  height: 200, color: Colors.blue,)));
  }

}