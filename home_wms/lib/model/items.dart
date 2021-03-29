import 'package:hive/hive.dart';

part 'items.g.dart';

@HiveType(typeId: 1)
class Item
{


  @HiveField(0)
  String name;
  @HiveField(1)
  int quantity;


  Item(this.name, this.quantity);
}






