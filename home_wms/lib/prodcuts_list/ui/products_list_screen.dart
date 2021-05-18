import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/model/products/products.dart';
import 'package:home_wms/loading_animation.dart';

import 'package:home_wms/prodcuts_list/bloc/products_list_bloc.dart';
import 'package:home_wms/prodcuts_list/ui/products_edit_screen.dart';

class ProductsListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProductsListScreenState();
}

class ProductsListScreenState extends State<ProductsListScreen> {
  final productsBox = Hive.box('products');

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductsListBloc>(context).add(LoadProductsEvent());
  }

  @override
  void dispose() {
  productsBox.close();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return Scaffold(appBar: _buildAppbar(), body: _buildlistScreen());
}

AppBar _buildAppbar() =>
    AppBar(
      title: (Text("Products List")),
      backgroundColor: Colors.greenAccent,
      centerTitle: true,
    );

Widget _buildlistScreen() =>
    Column(children: [
      _searchField(),
      BlocBuilder<ProductsListBloc, ProductsListState>(
        builder: (context, state) {
          if (state is LoadingProdcutsListState) {
            return LoadingAnimation();
          } else if (state is LoadedProdcutsListState) {
            return _buildProductsList();
          } else if (state is LoadedProductsListSearchState) {
            return _listSearched(state.listOfObjects);
          } else {
            return _buildProductsList();
          }
        },
      )
    ]);

Widget _buildProductsList() => Expanded(
      child: ListView.builder(
          itemCount: productsBox.length,
          itemBuilder: (context, index) {
            final product = productsBox.getAt(index) as Product;
            return _listTile(product);
          }));


Widget _listSearched(List listOfProducts) => Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) => _listTile(listOfProducts[index]),
        itemCount: listOfProducts.length,
      ));


Widget _listTile(Product product) =>
    Slidable(
        actions: <Widget>[
          IconSlideAction(
              caption: 'Delete',
              color: Colors.blue,
              icon: Icons.delete,
              onTap: () => {})
        ],
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
                onTap: () => _buildEditScreen(product),
                title: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 4)),
                      ],
                    ),
                    child: Column( children: [ 
                      Text(product.name, textAlign: TextAlign.center,),
                      Table(
                    children: [
                      TableRow(children:[
                        Text('Category: '),
                        Text(product.category, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('Quantity: '),
                        Text(product.quantity.toString(), maxLines: 1, overflow: TextOverflow.ellipsis)

                      ] ),
                      TableRow(children:[
                        Text('Producer: '),
                        Text(product.producer, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('Price: '),
                        Text(product.price.toString(), maxLines: 1, overflow: TextOverflow.ellipsis),] ),

                    ],

                    )
                    ]
                    )))));

Widget _searchField() =>
    TextField(
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
        onChanged: (text) {
          _getSearch(text);
        },
        textInputAction: TextInputAction.next,
        maxLength: 50,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
            labelText: 'Search'));

_getSearch(text) =>
    BlocProvider.of<ProductsListBloc>(context)
        .add(GetSearchEvent(text));

_navigateToEditScreen(product) {
  Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => ProductEditScreen(product)));
}

_buildEditScreen(product) async {
  await Hive.openBox('categories');
  await Hive.openBox('producers');
  _navigateToEditScreen(product);
}}
