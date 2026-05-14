// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'destination.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DestinationAdapter extends TypeAdapter<Destination> {
  @override
  final int typeId = 2;

  @override
  Destination read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Destination(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      imageUrl: fields[3] as String,
      rating: fields[4] as double,
      location: fields[5] as String,
      arrivalTime: fields[6] as String?,
      departureTime: fields[7] as String?,
      latitude: fields[8] as double?,
      longitude: fields[9] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Destination obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.arrivalTime)
      ..writeByte(7)
      ..write(obj.departureTime)
      ..writeByte(8)
      ..write(obj.latitude)
      ..writeByte(9)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DestinationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
