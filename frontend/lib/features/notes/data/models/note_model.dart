import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/note.dart';
import '../../../auth/data/models/user_model.dart';

part 'note_model.g.dart';

@JsonSerializable()
class NoteModel extends Equatable {
  final int id;
  final String content;
  @JsonKey(name: 'thread_id') final int threadId;
  @JsonKey(name: 'user_id') final int userId;
  final UserModel? user;
  @JsonKey(name: 'created_at') final DateTime createdAt;
  @JsonKey(name: 'updated_at') final DateTime updatedAt;

  const NoteModel({
    required this.id,
    required this.content,
    required this.threadId,
    required this.userId,
    this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => _$NoteModelFromJson(json);
  Map<String, dynamic> toJson() => _$NoteModelToJson(this);

  Note toEntity() {
    return Note(
      id: id,
      content: content,
      threadId: threadId,
      userId: userId,
      user: user?.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      content: note.content,
      threadId: note.threadId,
      userId: note.userId,
      user: note.user != null ? UserModel.fromEntity(note.user!) : null,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    content,
    threadId,
    userId,
    user,
    createdAt,
    updatedAt,
  ];
}
