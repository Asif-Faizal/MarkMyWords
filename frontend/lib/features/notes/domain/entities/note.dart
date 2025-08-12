import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';

class Note extends Equatable {
  final int id;
  final String content;
  final int threadId;
  final int userId;
  final User? user;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.content,
    required this.threadId,
    required this.userId,
    this.user,
    required this.createdAt,
    required this.updatedAt,
  });

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
