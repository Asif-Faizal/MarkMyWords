// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invite _$InviteFromJson(Map<String, dynamic> json) => Invite(
  id: (json['id'] as num).toInt(),
  noteId: (json['note_id'] as num).toInt(),
  fromUserId: (json['from_user_id'] as num).toInt(),
  toUserId: (json['to_user_id'] as num).toInt(),
  status: $enumDecode(_$InviteStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  note: Note.fromJson(json['note'] as Map<String, dynamic>),
  fromUser: User.fromJson(json['from_user'] as Map<String, dynamic>),
  toUser: User.fromJson(json['to_user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$InviteToJson(Invite instance) => <String, dynamic>{
  'id': instance.id,
  'note_id': instance.noteId,
  'from_user_id': instance.fromUserId,
  'to_user_id': instance.toUserId,
  'status': _$InviteStatusEnumMap[instance.status]!,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'note': instance.note,
  'from_user': instance.fromUser,
  'to_user': instance.toUser,
};

const _$InviteStatusEnumMap = {
  InviteStatus.pending: 'pending',
  InviteStatus.accepted: 'accepted',
  InviteStatus.declined: 'declined',
};
