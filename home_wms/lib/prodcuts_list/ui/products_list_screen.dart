import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:home_wms/model/products/products.dart';
import 'package:home_wms/loading_animation.dart';

import 'package:home_wms/prodcuts_list/bloc/products_list_bloc.dart';

class ProductsListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProductsListScreenState();
}

class ProductsListScreenState extends State<ProductsListScreen> {
  final searchTextFieldController = TextEditingController();
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

  AppBar _buildAppbar() => AppBar(
        title: _buildAppbarTitle(),
        shadowColor: Colors.green,
        foregroundColor: Colors.greenAccent,
      );

  Widget _buildlistScreen() => Column(children: [
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

  Widget _buildProductsList() {
    return Expanded(
        child: ListView.builder(
            itemCount: productsBox.length,
            itemBuilder: (context, index) {
              final product = productsBox.getAt(index) as Product;
              return _listTile(product);
            }));
  }

  Widget _listSearched(List listOfProducts) {
    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, index) => _listTile(listOfProducts[index]),
      itemCount: listOfProducts.length,
    ));
  }

  Widget _listTile(product) => ListTile(
      minVerticalPadding: 2,
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
          child: Column(children: [
            Text(
              product.name,
              textAlign: TextAlign.center,
            ),
            Row(
              children: [
                Column(children: [
                  Text(
                    'Name: ' + product.category,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'Producent: ' + product.producer,
                    textAlign: TextAlign.left,
                  )]),
                  Spacer(),
                  Column(children: [
                  Text(
                    'Quantity:',
                     
                  ),
                  Text(
                    'Price:',
                   
                  )
                ])
              ,Column(children: [
                  Text(
                    product.quantity.toString(),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    product.price.toString(),
                    textAlign: TextAlign.right,
                  )
                ])
            
          ])])));

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

  _getSearch() => BlocProvider.of<ProductsListBloc>(context)
      .add(GetSearchEvent(searchTextFieldController.text));

  Widget _buildAppbarTitle() => Row(children: [
        Text("List"),
      ]);
}
