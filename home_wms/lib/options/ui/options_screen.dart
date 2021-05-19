import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/model/producer/producer.dart';
import 'package:home_wms/model/products/products.dart';

class OptionsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OptionsScreenState();
}

class OptionsScreenState extends State<OptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            return Colors.greenAccent;
          }),
          overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.green.shade900;
            }
            return Colors.greenAccent;
          }),
        ),
        child: Text(
          "Delete Products DB",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          await Hive.openBox('products');
          await Hive.box('products').deleteFromDisk();
        },
      ),
      OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            return Colors.amberAccent;
          }),
          overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.amber.shade900;
            }
            return Colors.amberAccent;
          }),
        ),
        child: Text(
          "Delete Categories DB",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          await Hive.openBox('categories');
          await Hive.box('categories').deleteFromDisk();
        },
      ),
      OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            return Colors.amberAccent;
          }),
          overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.amber.shade900;
            }
            return Colors.amberAccent;
          }),
        ),
        child: Text(
          "Delete Producers DB",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          await Hive.openBox('producers');
          await Hive.box('producers').deleteFromDisk();
        },
      ),
      OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              return Colors.greenAccent;
            }),
            overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.green.shade900;
              }
              return Colors.greenAccent;
            }),
          ),
          child: Text(
            "Add Random Products DB",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            await Hive.openBox('products');
            await Hive.openBox('categories');
            await Hive.openBox('producers');

            if (Hive.box('products').isEmpty) {
              Hive.box('products').add(
                  new Product('Box', 10, '2141261214', 'Paper', 'Boxy', 4.5));
              Hive.box('products').add(new Product(
                  'Paper', 1025, '512578821321', 'Paper', 'Paper Master', 2));
              Hive.box('products').add(new Product(
                  'Big box', 44, '2142146', 'Paper', 'Paper Master', 9));
              Hive.box('products').add(new Product(
                  'Notebook', 22, '1241241256', 'Paper', 'Paper Master', 3.5));
              Hive.box('products').add(new Product(
                  'Book', 50, '5475351551', 'Paper', 'Library', 15.5));
              Hive.box('products').add(new Product(
                  'Diary', 22, '5315437781', 'Paper', 'Library', 10.2));
              Hive.box('products').add(new Product(
                  'NewsPaper', 33, '1231254567', 'Paper', 'Library', 9.99));

              Hive.box('products').add(new Product('Monument', 1,
                  '257908754423', 'Rock', 'Monument Maker', 10000000000));
              Hive.box('products').add(new Product(
                  'Bust', 12, '2141261214', 'Rock', 'Monument Maker', 500));
              Hive.box('products').add(new Product('Shiny pebble', 241,
                  '55321412515', 'Rock', 'Pebble Corp.', 1));
              Hive.box('products').add(new Product(
                  'Diamond', 4, '24142153466', 'Rock', 'Pebble Corp.', 50000));
              Hive.box('products').add(new Product(
                  'Ametyst', 5, '2421626612', 'Rock', 'Pebble Corp.', 50));
              Hive.box('products').add(new Product('Fake Dimond', 40,
                  '21412784643', 'Rock', 'Stoned Faker', 45));

              Hive.box('products').add(new Product('Scissors', 55, '512585547',
                  'Scissors', 'Sharp Company', 12));
              Hive.box('products').add(new Product('Hair Scissors', 442,
                  '24124124124214', 'Scissors', 'Sharp Company', 2));
              Hive.box('products').add(new Product('Papper Scissors', 210,
                  '6236356316', 'Scissors', 'Sharp Company', 9));
              Hive.box('products').add(new Product('Clippers', 42, '547575479',
                  'Scissors', 'Sharp Company', 3.5));

              Hive.box('categories').add('Paper');
              Hive.box('categories').add('Rock');
              Hive.box('categories').add('Scissors');

              Hive.box('producers')
                  .add(Producer('Boxy', 'Box 12-151 Poland', "Just Boxes"));
              Hive.box('producers').add(
                  Producer('Paper Master', 'Peperland 214', 'Paper and other'));
              Hive.box('producers').add(Producer(
                  'Library',
                  'FirsherStreet 24 Birmingham England',
                  "Reading is them passion"));
              Hive.box('producers').add(Producer(
                  'Pebble Corp.',
                  '744 Ramona Street Palo Alto, CA 94301 United States',
                  " Pebble Technology Corporation."));
              Hive.box('producers')
                  .add(Producer('Fake Dimond', 'Unknown', 'thives'));
              Hive.box('producers').add(Producer(
                  'Stoned Faker', 'GreenStraad 24 Amsterdam', 'Eco friendly '));

              Hive.box('producer')
                  .add(Producer('Scissors', 'SharpStraad 35 Den Haag', 'Sharp staff makers'));
           
            }
          })
    ]));
  }
}
