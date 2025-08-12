// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invite _$InviteFromJson(Map<String, dynamic> json) => Invite(
  id: (json['id'] as num).toInt(),
  noteId: (json['noteId'] as num).toInt(),
  fromUserId: (json['fromUserId'] as num).toInt(),
  toUserId: (json['toUserId'] as num).toInt(),
  status: $enumDecode(_$InviteStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  note: Note.fromJson(json['note'] as Map<String, dynamic>),
  fromUser: User.fromJson(json['fromUser'] as Map<String, dynamic>),
  toUser: User.fromJson(json['toUser'] as Map<String, dynamic>),
);

Map<String, dynamic> _$InviteToJson(Invite instance) => <String, dynamic>{
  'id': instance.id,
  'noteId': instance.noteId,
  'fromUserId': instance.fromUserId,
  'toUserId': instance.toUserId,
  'status': _$InviteStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'note': instance.note,
  'fromUser': instance.fromUser,
  'toUser': instance.toUser,
};

const _$InviteStatusEnumMap = {
  InviteStatus.pending: 'pending',
  InviteStatus.accepted: 'accepted',
  InviteStatus.declined: 'declined',
};
