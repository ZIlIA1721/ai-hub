// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_tool.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AIToolAdapter extends TypeAdapter<AITool> {
  @override
  final int typeId = 0;

  @override
  AITool read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AITool(
      id: fields[0] as String?,
      name: fields[1] as String,
      url: fields[2] as String,
      iconUrl: fields[3] as String?,
      color: fields[4] as String?,
      isPreset: fields[5] as bool,
      createdAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AITool obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.iconUrl)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.isPreset)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIToolAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
