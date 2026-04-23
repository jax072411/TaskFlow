// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppNotificationAdapter extends TypeAdapter<AppNotification> {
  @override
  final int typeId = 8;

  @override
  AppNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppNotification(
      id: fields[0] as String,
      type: fields[1] as NotificationType,
      title: fields[2] as String,
      message: fields[3] as String,
      relatedId: fields[4] as String?,
      isRead: fields[5] as bool,
      createdAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AppNotification obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.relatedId)
      ..writeByte(5)
      ..write(obj.isRead)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationTypeAdapter extends TypeAdapter<NotificationType> {
  @override
  final int typeId = 7;

  @override
  NotificationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationType.taskAssigned;
      case 1:
        return NotificationType.taskStatusChanged;
      case 2:
        return NotificationType.taskDeadline;
      case 3:
        return NotificationType.commentMention;
      case 4:
        return NotificationType.projectUpdate;
      default:
        return NotificationType.taskAssigned;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationType obj) {
    switch (obj) {
      case NotificationType.taskAssigned:
        writer.writeByte(0);
        break;
      case NotificationType.taskStatusChanged:
        writer.writeByte(1);
        break;
      case NotificationType.taskDeadline:
        writer.writeByte(2);
        break;
      case NotificationType.commentMention:
        writer.writeByte(3);
        break;
      case NotificationType.projectUpdate:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
