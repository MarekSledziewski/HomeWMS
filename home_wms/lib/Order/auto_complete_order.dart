import 'package:hive/hive.dart';
import 'package:home_wms/model/products/products.dart';

class AutoCompleteOrderProduct {
   final List<Product> listProduct =
  Hive
      .box('products')
      .values
      .toList()
      .cast<Product>();

   Future<List<Product>> getProductNameSuggestions(String query) async
  =>
      List.of(listProduct)
          .where((_product) =>
          _product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

}
