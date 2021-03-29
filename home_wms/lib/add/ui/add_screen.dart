import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_wms/add/add/add_bloc.dart';

class AddScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddScreenState();
}

class AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: _buildBloc(),
    );
  }

  final itemNameFieldController = TextEditingController();
  final quantityFieldController = TextEditingController();

  Widget _buildBloc() => BlocBuilder<AddBloc, AddState>(
        builder: (context, state) {
          if (state is InitialAddState) {
            return _buildBody();
          } else if (state is ProdcutAdded) {
            return _buildBody();
          } else if (state is ScannInputState) {
            // TOOD add Scanner build here
            return Text("Scanner Output");
          } else {
            return Center(child: Text('Error on Bloc Builder'));
          }
        },
      );

  Widget _buildBody() => Column(
        children: [
          itemNameTextField(),
          quantityField(),
          Align(
            alignment: Alignment.bottomRight,
            child: buildAddButton(),
          )
        ],
      );

  Widget itemNameTextField() => TextField(
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
      textInputAction: TextInputAction.next,
      maxLength: 100,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: itemNameFieldController,
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

  Widget quantityField() => TextField(
      keyboardType: TextInputType.number,
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
      },
      textInputAction: TextInputAction.next,
      maxLength: 20,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: quantityFieldController,
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
          hintText: 'quantity'));

  Widget buildAddButton() => OutlinedButton(
        onPressed: () {
          if (itemNameFieldController.text.isNotEmpty &&
              quantityFieldController.text.isNotEmpty) {
            _addConfirmDialog();
          } else {
            _emptyFields();
          }
        },
        child: Text("Add Product"),
      );

  _addEvent(bool addSimilar) =>
    BlocProvider.of<AddBloc>(context).add(AddItemEvent(itemNameFieldController.text, int.parse(quantityFieldController.text)));

  _addConfirmDialog() => showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
              title: Text('Add Product?'),
              content: Text('Add your product to the Database'),
              actions: [
                OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                OutlinedButton(
                    onPressed: () {
                      _addEvent(false);
                      itemNameFieldController.clear();
              quantityFieldController.clear();
                     Navigator.pop(context);

                    },
                    child: Text("Add")), 
                    OutlinedButton(
                    onPressed: () {
                      
                      _addEvent(true);
                  Navigator.pop(context);

                    },
                    child: Text("Add Similar"))
              ]),);

  _emptyFields() => showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(title: Text('Fill requaierd fields'), actions: [
            OutlinedButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                })
          ]));
}
