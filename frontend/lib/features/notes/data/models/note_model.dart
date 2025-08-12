import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/note.dart';
import '../../../auth/data/models/user_model.dart';

part 'note_model.g.dart';

@JsonSerializable()
class NoteModel extends Equatable {
  final int id;
  final String title;
  final String content;
  final bool isPrivate;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel? user;
  final List<UserModel> collaborators;

  const NoteModel({
    required this.id,
    required this.title,
    required this.content,
    @JsonKey(name: 'is_private') required this.isPrivate,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    this.user,
    this.collaborators = const [],
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => _$NoteModelFromJson(json);
  Map<String, dynamic> toJson() => _$NoteModelToJson(this);

  Note toEntity() {
    return Note(
      id: id,
      title: title,
      content: content,
      isPrivate: isPrivate,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      user: user?.toEntity(),
      collaborators: collaborators.map((u) => u.toEntity()).toList(),
    );
  }

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

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    isPrivate,
    userId,
    createdAt,
    updatedAt,
    user,
    collaborators,
  ];
}
