import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/thread.dart';
import '../../../auth/data/models/user_model.dart';

part 'thread_model.g.dart';

@JsonSerializable()
class ThreadModel extends Equatable {
  final int id;
  final String title;
  final String description;
  @JsonKey(name: 'is_private') final bool isPrivate;
  @JsonKey(name: 'user_id') final int userId;
  final UserModel? user;
  final List<UserModel> collaborators;
  @JsonKey(name: 'notes_count') final int notesCount;
  @JsonKey(name: 'created_at') final DateTime createdAt;
  @JsonKey(name: 'updated_at') final DateTime updatedAt;

  const ThreadModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isPrivate,
    required this.userId,
    this.user,
    this.collaborators = const [],
    required this.notesCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ThreadModel.fromJson(Map<String, dynamic> json) => _$ThreadModelFromJson(json);
  Map<String, dynamic> toJson() => _$ThreadModelToJson(this);

  Thread toEntity() {
    return Thread(
      id: id,
      title: title,
      description: description,
      isPrivate: isPrivate,
      userId: userId,
      user: user?.toEntity(),
      collaborators: collaborators.map((u) => u.toEntity()).toList(),
      notesCount: notesCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ThreadModel.fromEntity(Thread thread) {
    return ThreadModel(
      id: thread.id,
      title: thread.title,
      description: thread.description,
      isPrivate: thread.isPrivate,
      userId: thread.userId,
      user: thread.user != null ? UserModel.fromEntity(thread.user!) : null,
      collaborators: thread.collaborators.map((u) => UserModel.fromEntity(u)).toList(),
      notesCount: thread.notesCount,
      createdAt: thread.createdAt,
      updatedAt: thread.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    isPrivate,
    userId,
    user,
    collaborators,
    notesCount,
    createdAt,
    updatedAt,
  ];
}
