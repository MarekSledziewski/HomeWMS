// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'producer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProducerAdapter extends TypeAdapter<Producer> {
  @override
  final int typeId = 1;

  @override
  Producer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Producer(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Producer obj) {
    writer
      ..writeByte(3)..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.adress)
      ..writeByte(2)
      ..write(obj.descryption);
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
