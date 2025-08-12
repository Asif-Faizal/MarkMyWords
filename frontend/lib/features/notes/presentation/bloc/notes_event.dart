import 'package:equatable/equatable.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

class LoadThreadNotes extends NotesEvent {
  final int threadId;

  const LoadThreadNotes(this.threadId);

  @override
  List<Object?> get props => [threadId];
}

class CreateNote extends NotesEvent {
  final String content;
  final int threadId;

  const CreateNote({
    required this.content,
    required this.threadId,
  });

  @override
  List<Object?> get props => [content, threadId];
}

class UpdateNote extends NotesEvent {
  final int id;
  final String content;

  const UpdateNote({
    required this.id,
    required this.content,
  });

  @override
  List<Object?> get props => [id, content];
}

class DeleteNote extends NotesEvent {
  final int id;

  const DeleteNote(this.id);

  @override
  List<Object?> get props => [id];
}
