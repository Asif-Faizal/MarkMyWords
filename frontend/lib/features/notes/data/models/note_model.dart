import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/note.dart';
import '../../../auth/data/models/user_model.dart';

part 'note_model.g.dart';

@JsonSerializable()
class NoteModel extends Note {
  const NoteModel({
    required super.id,
    required super.title,
    required super.content,
    required super.isPrivate,
    required super.userId,
    required super.createdAt,
    required super.updatedAt,
    super.user,
    super.collaborators = const [],
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => _$NoteModelFromJson(json);
  Map<String, dynamic> toJson() => _$NoteModelToJson(this);

  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      isPrivate: note.isPrivate,
      userId: note.userId,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      user: note.user != null ? UserModel.fromEntity(note.user!) : null,
      collaborators: note.collaborators.map((u) => UserModel.fromEntity(u)).toList(),
    );
  }
}
