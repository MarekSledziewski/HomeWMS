import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_wms/model/producer/producer.dart';
import 'package:home_wms/producer/bloc/producer_bloc.dart';

// ignore: must_be_immutable
class AddProducerScreen extends StatelessWidget {
  bool edit = false;
  
  AddProducerScreen.values(Producer producer) {
     oldProducer = producer;
    producerNameFieldContrroler.text = producer.name;
    producerAdressFieldContrroler.text = producer.adress;
    producerDescryptionFieldContrroler.text = producer.descryption;
    edit = true;
  }
  AddProducerScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(),
        body: ListView(
          children: [
            productQuantityField(context),
            producerAdressTextField(context),
            producerDescryptionField(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                _returnButton(context),
              
                _okButton(context),
              ],
            )
          ],
        ));
  }
  late final Producer oldProducer; 
  final producerNameFieldContrroler = TextEditingController();
  final producerAdressFieldContrroler = TextEditingController();
  final producerDescryptionFieldContrroler = TextEditingController();

  AppBar _buildAppbar() => AppBar(
        title: (Text("Producer")),
        backgroundColor: Colors.amber,
        centerTitle: true,
      );

  Widget productQuantityField(context) => TextField(
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
      textInputAction: TextInputAction.next,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: producerNameFieldContrroler,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          filled: true,
          counter: Offstage(),
          fillColor: Colors.white,
          border: InputBorder.none,
          hintText: 'Name'));

  Widget producerAdressTextField(context) => TextField(
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
      textInputAction: TextInputAction.next,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: producerAdressFieldContrroler,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          filled: true,
          counter: Offstage(),
          fillColor: Colors.white,
          border: InputBorder.none,
          hintText: 'Adress'));

  Widget producerDescryptionField(context) => TextField(
      maxLines: 20,
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
      textInputAction: TextInputAction.next,
      controller: producerDescryptionFieldContrroler,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          filled: true,
          counter: Offstage(),
          fillColor: Colors.white,
          border: InputBorder.none,
          hintText: 'Descryptiom'));

  Widget _okButton(context) => OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            return Colors.redAccent;
          }),
          overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.red.shade900;
            }
            return Colors.transparent;
          }),
        ),
        child: Text(
          "Ok",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          if (producerNameFieldContrroler.text.isNotEmpty && edit==false) {
            Navigator.pop(context);
            BlocProvider.of<ProducerBloc>(context).add(AddProducerEvent(
                producerNameFieldContrroler.text,
                producerAdressFieldContrroler.text,
                producerNameFieldContrroler.text));
          } else if (producerNameFieldContrroler.text.isNotEmpty && edit==true ) {
              Navigator.pop(context);
                 BlocProvider.of<ProducerBloc>(context).add(EditproducerEvent(
                oldProducer,
                producerNameFieldContrroler.text,
                producerAdressFieldContrroler.text,
                producerDescryptionFieldContrroler.text));
          } else {
            _emptyFields(context);
          }
        },
      );


  Widget _returnButton(context) => OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            return Colors.blueAccent;
          }),
          overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.blue.shade900;
            }
            return Colors.transparent;
          }),
        ),
        child: Text(
          "Return",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      );

  _emptyFields(context) => showDialog(

      context: context,
      builder: (BuildContext context) =>
          AlertDialog(title: Text('Fill requaierd fields'), actions: [
            OutlinedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    return Colors.redAccent;
                  }),
                  overlayColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.red.shade900;
                    }
                    return Colors.transparent;
                  }),
                ),
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                })
          ]));


}
