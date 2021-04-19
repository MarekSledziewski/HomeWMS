// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProducerAdapter extends TypeAdapter<ProductCategory> {
  @override
  final int typeId = 2;

  @override
  ProductCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductCategory(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProductCategory obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProducerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
