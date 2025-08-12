import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';

class Thread extends Equatable {
  final int id;
  final String title;
  final String description;
  final bool isPrivate;
  final int userId;
  final User? user;
  final List<User> collaborators;
  final int notesCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Thread({
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
