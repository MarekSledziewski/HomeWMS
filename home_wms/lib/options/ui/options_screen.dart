import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class OptionsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OptionsScreenState();
}

class OptionsScreenState extends State<OptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: [
      Spacer(),
      InkWell(
          onTap: () async {
            await Hive.openBox('products');
            await Hive.box('products').deleteFromDisk();
          },
          child: Container(
            width: 200,
            height: 200,
            color: Colors.yellowAccent,
            child: Text("delete whole database products"),
          )),
      InkWell(
          onTap: () async {
            await Hive.openBox('categories');
            await Hive.box('categories').deleteFromDisk();
          },
          child: Container(
            width: 200,
            height: 200,
            color: Colors.yellowAccent,
            child: Text("delete whole database Categories"),
          ))
    ])));
  }
}
