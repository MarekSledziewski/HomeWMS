import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/loading_animation.dart';
import 'package:home_wms/producer/bloc/producer_bloc.dart';
import 'producer_add_and_edit_screen.dart';

class ProducerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProducerScreenState();
}

class ProducerScreenState extends State<ProducerScreen> {
  final searchTextFieldController = TextEditingController();

  final producersBox = Hive.box('producers');

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProducerBloc>(context).add(LoadProducersEvent());
  }

  @override
  void dispose() {
    producersBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(),
        body: Column(children: [
          _searchField(),
          _buildBlocBuilder(),
          Align(
            alignment: Alignment.bottomRight,
            child: _addProducerButton(),
          )
        ]));
  }

  AppBar _buildAppbar() => AppBar(
        title: (Text("Producers")),
        backgroundColor: Colors.amber,
        centerTitle: true,
      );

  Widget _buildBlocBuilder() =>
      BlocBuilder<ProducerBloc, ProducerState>(builder: (context, state) {
        if (state is LoadingProducerListState) {
          return LoadingAnimation();
        } else if (state is LoadedProducerListSearchState) {
          return __buildProducerListSearched(state.listOfProducers);
        } else {
          return _buildProducerList();
        }
      });

  Widget _buildProducerList() {
    return Expanded(
        child: ListView.builder(
            itemCount: producersBox.length,
            itemBuilder: (context, index) {
              final producer = producersBox.getAt(index);
              return _listTile(producer);
            }));
  }

  Widget __buildProducerListSearched(List listOfProducers) {
    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, index) => _listTile(listOfProducers[index]),
      itemCount: listOfProducers.length,
    ));
  }

  Widget _listTile(producer) => Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1)),
              ],
            ),
            child: ListTile(
                minVerticalPadding: 2,
                title: Text(producer.name,
                  textAlign: TextAlign.center,
                )),
          ),
          actions: <Widget>[
            IconSlideAction(
                caption: 'Delete',
                color: Colors.blue,
                icon: Icons.delete,
                onTap: () => {
                      _deleteProducer(producer),
                    })
          ]);

  Widget _searchField() => TextField(
      onEditingComplete: () {
        _getSearch();
        FocusScope.of(context).unfocus();
      },
      textInputAction: TextInputAction.next,
      maxLength: 50,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: searchTextFieldController,
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
          prefixIcon: Icon(Icons.search),
          hintText: 'Search'));

  _getSearch() => BlocProvider.of<ProducerBloc>(context)
      .add(GetSearchEvent(searchTextFieldController.text));

  Widget _addProducerButton() => FloatingActionButton(
      backgroundColor: Colors.redAccent,
      hoverColor: Colors.redAccent,
      splashColor: Colors.redAccent,
      onPressed: () => Navigator.push(context,
      new MaterialPageRoute(builder: (context) => AddProducerScreen())),
      child: Icon(
        Icons.add,
      ));

  _deleteProducer(producer) {
    BlocProvider.of<ProducerBloc>(context).add(DeleteProducerEvent(producer));
  }
}
