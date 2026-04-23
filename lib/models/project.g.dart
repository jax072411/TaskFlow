// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 1;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      startDate: fields[3] as DateTime?,
      endDate: fields[4] as DateTime?,
      status: fields[5] as ProjectStatus,
      coverImage: fields[6] as String?,
      ownerId: fields[7] as String?,
      memberIds: (fields[8] as List?)?.cast<String>(),
      createdAt: fields[9] as DateTime?,
    )..updatedAt = fields[10] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.coverImage)
      ..writeByte(7)
      ..write(obj.ownerId)
      ..writeByte(8)
      ..write(obj.memberIds)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProjectStatusAdapter extends TypeAdapter<ProjectStatus> {
  @override
  final int typeId = 0;

  @override
  ProjectStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProjectStatus.notStarted;
      case 1:
        return ProjectStatus.inProgress;
      case 2:
        return ProjectStatus.completed;
      case 3:
        return ProjectStatus.archived;
      default:
        return ProjectStatus.notStarted;
    }
  }

  @override
  void write(BinaryWriter writer, ProjectStatus obj) {
    switch (obj) {
      case ProjectStatus.notStarted:
        writer.writeByte(0);
        break;
      case ProjectStatus.inProgress:
        writer.writeByte(1);
        break;
      case ProjectStatus.completed:
        writer.writeByte(2);
        break;
      case ProjectStatus.archived:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
