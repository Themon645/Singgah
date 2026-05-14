// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripAdapter extends TypeAdapter<Trip> {
  @override
  final int typeId = 1;

  @override
  Trip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trip(
      id: fields[0] as String,
      name: fields[1] as String,
      origin: fields[2] as String,
      destination: fields[3] as String,
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime,
      vehicleType: fields[6] as String,
      status: fields[7] as TripStatus,
      progress: fields[8] as double,
      itinerary: (fields[9] as List).cast<Destination>(),
      hotel: fields[10] as Destination?,
    );
  }

  @override
  void write(BinaryWriter writer, Trip obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.origin)
      ..writeByte(3)
      ..write(obj.destination)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.vehicleType)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.progress)
      ..writeByte(9)
      ..write(obj.itinerary)
      ..writeByte(10)
      ..write(obj.hotel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TripStatusAdapter extends TypeAdapter<TripStatus> {
  @override
  final int typeId = 0;

  @override
  TripStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TripStatus.upcoming;
      case 1:
        return TripStatus.ongoing;
      case 2:
        return TripStatus.finished;
      default:
        return TripStatus.upcoming;
    }
  }

  @override
  void write(BinaryWriter writer, TripStatus obj) {
    switch (obj) {
      case TripStatus.upcoming:
        writer.writeByte(0);
        break;
      case TripStatus.ongoing:
        writer.writeByte(1);
        break;
      case TripStatus.finished:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
