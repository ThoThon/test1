// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginInfoAdapter extends TypeAdapter<LoginInfo> {
  @override
  final int typeId = 0;

  @override
  LoginInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginInfo(
      username: fields[0] as String,
      password: fields[1] as String,
      taxCode: fields[2] as String,
      token: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LoginInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.taxCode)
      ..writeByte(3)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
