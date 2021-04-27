import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_wms/delete/bloc/delete_bloc.dart';

class DeleteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DeleteScreenState();
}

class DeleteScreenState extends State<DeleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBloc(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  final productNameFieldController = TextEditingController();
  final quantityFieldController = TextEditingController();

  Widget _buildBloc() => BlocBuilder<DeleteBloc, DeleteState>(
        builder: (context, state) {
          if (state is InitialDeleteState) {
            return _buildBody();
          } else if (state is ProdcutDeleted) {
            return _buildBody();
          } else if (state is ScanInputState) {
            // TOOD add Scanner build here
            return Text("Scanner Output");
          } else if (state is NoSuchProductState) {
            return _noSuchProductDialog();
          } else {
            return Center(child: Text('Error on Bloc Builder'));
          }
        },
      );

  Widget _buildBody() => Column(
        children: [
          productNameTextField(),
          quantityField(),
          Align(
            alignment: Alignment.bottomRight,
            child: buildDeleteButton(),
          )
        ],
      );

  Widget productNameTextField() => TextField(
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
      textInputAction: TextInputAction.next,
      maxLength: 100,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: productNameFieldController,
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
          labelText: 'Name'));

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
          labelText: 'quantity'));

  Widget buildDeleteButton() => OutlinedButton(
        onPressed: () {
          if (productNameFieldController.text.isNotEmpty &&
              quantityFieldController.text.isNotEmpty) {
            _deleteConfirmDialog();
          } else {
            _emptyFields();
          }
        },
        child: Text("Delete Product"),
      );

  _deleteEvent(bool deleteSimilar) =>
      BlocProvider.of<DeleteBloc>(context).add(DeleteProductEvent(
          productNameFieldController.text,
          int.parse(quantityFieldController.text)));

  _deleteConfirmDialog() => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: Text('Delete Product?'),
            content: Text('Delete this product'),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              OutlinedButton(
                  onPressed: () {
                    _deleteEvent(false);
                    productNameFieldController.clear();
                    quantityFieldController.clear();
                    Navigator.pop(context);
                  },
                  child: Text("Delete")),
              OutlinedButton(
                  onPressed: () {
                    _deleteEvent(true);
                    Navigator.pop(context);
                  },
                  child: Text("Delete Similar"))
            ]),
      );
  _noSuchProductDialog() => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: Text('Product not found'),
            content: Text('There is no such prodcut in database'),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Ok",
                    textAlign: TextAlign.center,
                  )),
            ]),
      );

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

 AppBar _buildAppbar() => AppBar(
        title: (Text("Delete Product")),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      );
}
