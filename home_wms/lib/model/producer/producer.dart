import 'package:hive/hive.dart';

part 'producer.g.dart';


@HiveType(typeId: 1)
class Producer {
  @HiveField(0)
  String name;
  @HiveField(1)
  String adress;
  @HiveField(2)
  String descryption;

  Producer(this.name, this.adress, this.descryption);
}
