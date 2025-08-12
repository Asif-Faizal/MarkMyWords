// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteModel _$NoteModelFromJson(Map<String, dynamic> json) => NoteModel(
  id: (json['id'] as num).toInt(),
  content: json['content'] as String,
  threadId: (json['thread_id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  user: json['user'] == null
      ? null
      : UserModel.fromJson(json['user'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$NoteModelToJson(NoteModel instance) => <String, dynamic>{
  'id': instance.id,
  'content': instance.content,
  'thread_id': instance.threadId,
  'user_id': instance.userId,
  'user': instance.user,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
