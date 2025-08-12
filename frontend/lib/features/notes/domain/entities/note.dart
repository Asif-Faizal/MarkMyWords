import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';

class Note extends Equatable {
  final int id;
  final String title;
  final String content;
  final bool isPrivate;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;
  final List<User> collaborators;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.isPrivate,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.collaborators = const [],
  });

  Note copyWith({
    int? id,
    String? title,
    String? content,
    bool? isPrivate,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
    List<User>? collaborators,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isPrivate: isPrivate ?? this.isPrivate,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      collaborators: collaborators ?? this.collaborators,
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
