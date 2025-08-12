import 'package:json_annotation/json_annotation.dart';
import 'note.dart';
import 'user.dart';

part 'invite.g.dart';

enum InviteStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('declined')
  declined,
}

@JsonSerializable()
class Invite {
  final int id;
  final int noteId;
  final int fromUserId;
  final int toUserId;
  final InviteStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Note note;
  final User fromUser;
  final User toUser;

  Invite({
    required this.id,
    @JsonKey(name: 'note_id') required this.noteId,
    @JsonKey(name: 'from_user_id') required this.fromUserId,
    @JsonKey(name: 'to_user_id') required this.toUserId,
    required this.status,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    required this.note,
    @JsonKey(name: 'from_user') required this.fromUser,
    @JsonKey(name: 'to_user') required this.toUser,
  });

  factory Invite.fromJson(Map<String, dynamic> json) => _$InviteFromJson(json);
  Map<String, dynamic> toJson() => _$InviteToJson(this);
}
