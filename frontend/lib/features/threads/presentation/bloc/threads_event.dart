import 'package:equatable/equatable.dart';

abstract class ThreadsEvent extends Equatable {
  const ThreadsEvent();

  @override
  List<Object?> get props => [];
}

class LoadThreads extends ThreadsEvent {}

class LoadCollaborativeThreads extends ThreadsEvent {}

class CreateThread extends ThreadsEvent {
  final String title;
  final String description;
  final bool isPrivate;

  const CreateThread({
    required this.title,
    required this.description,
    required this.isPrivate,
  });

  @override
  List<Object?> get props => [title, description, isPrivate];
}

class UpdateThread extends ThreadsEvent {
  final int id;
  final String? title;
  final String? description;
  final bool? isPrivate;

  const UpdateThread({
    required this.id,
    this.title,
    this.description,
    this.isPrivate,
  });

  @override
  List<Object?> get props => [id, title, description, isPrivate];
}

class DeleteThread extends ThreadsEvent {
  final int id;

  const DeleteThread(this.id);

  @override
  List<Object?> get props => [id];
}
