// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadModel _$ThreadModelFromJson(Map<String, dynamic> json) => ThreadModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  isPrivate: json['is_private'] as bool,
  userId: (json['user_id'] as num).toInt(),
  user: json['user'] == null
      ? null
      : UserModel.fromJson(json['user'] as Map<String, dynamic>),
  collaborators:
      (json['collaborators'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  notesCount: (json['notes_count'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ThreadModelToJson(ThreadModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'is_private': instance.isPrivate,
      'user_id': instance.userId,
      'user': instance.user,
      'collaborators': instance.collaborators,
      'notes_count': instance.notesCount,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
