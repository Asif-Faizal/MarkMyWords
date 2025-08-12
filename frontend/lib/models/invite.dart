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
    required this.noteId,
    required this.fromUserId,
    required this.toUserId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.note,
    required this.fromUser,
    required this.toUser,
  });

  factory Invite.fromJson(Map<String, dynamic> json) => _$InviteFromJson(json);
  Map<String, dynamic> toJson() => _$InviteToJson(this);
}
