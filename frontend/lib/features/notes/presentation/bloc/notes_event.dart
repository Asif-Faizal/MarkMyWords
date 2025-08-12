part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NotesEvent {}

class CreateNote extends NotesEvent {
  final String title;
  final String content;
  final bool isPrivate;

  const CreateNote({
    required this.title,
    required this.content,
    required this.isPrivate,
  });

  @override
  List<Object?> get props => [title, content, isPrivate];
}

class UpdateNote extends NotesEvent {
  final int id;
  final String? title;
  final String? content;
  final bool? isPrivate;

  const UpdateNote({
    required this.id,
    this.title,
    this.content,
    this.isPrivate,
  });

  @override
  List<Object?> get props => [id, title, content, isPrivate];
}

class DeleteNote extends NotesEvent {
  final int id;

  const DeleteNote({required this.id});

  @override
  List<Object?> get props => [id];
}

class LoadNote extends NotesEvent {
  final int id;

  const LoadNote({required this.id});

  @override
  List<Object?> get props => [id];
}

class JoinNoteSession extends NotesEvent {
  final int noteId;

  const JoinNoteSession({required this.noteId});

  @override
  List<Object?> get props => [noteId];
}

class LeaveNoteSession extends NotesEvent {
  final int noteId;

  const LeaveNoteSession({required this.noteId});

  @override
  List<Object?> get props => [noteId];
}

class NoteUpdated extends NotesEvent {
  final int noteId;
  final String content;
  final String? title;

  const NoteUpdated({
    required this.noteId,
    required this.content,
    this.title,
  });

  @override
  List<Object?> get props => [noteId, content, title];
}
