import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/list/bloc/list_bloc.dart';

class ListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  final searchTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ListBloc>(context).add(LoadItemsEvent());
  }
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
    body: _listScreen());
  }

  AppBar _buildAppbar() => AppBar(
        title: Text("List"),
        shadowColor: Colors.green,
        foregroundColor: Colors.greenAccent,
      );

  Widget _listScreen() =>Column(children: [
    _searchField(),
        BlocBuilder<ListBloc, ListState>(
          builder: (context, state) {
            if (state is LoadingListState) {
              return _buildLoadingAnimation();
            } else if (state is LoadedListState) {
              return  _list();
            } else {
              return Container(child: Text("Error try again later :("));
            }
          },
        )
      ]);

  Widget _list() => Expanded(
          child: ListView(
        children: [
          _itemList(),
          _itemList(),
          _itemList(),
        ],
      ));

  Widget _itemList() => Padding(
      padding: EdgeInsets.only(top: 2, bottom: 2),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          height: 60,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Text(
                'item',
                style: GoogleFonts.ubuntu(
                  textStyle: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          )));

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

  _getSearch() => BlocProvider.of<ListBloc>(context)
      .add(GetSearchEvent(searchTextFieldController.text));

  Widget _buildLoadingAnimation() => CircularProgressIndicator();
}
