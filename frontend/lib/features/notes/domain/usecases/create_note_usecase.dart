import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class CreateNoteUseCase {
  final NotesRepository repository;

  CreateNoteUseCase({required this.repository});

  Future<Either<Failure, Note>> call(CreateNoteParams params) async {
    return await repository.createNote(
      title: params.title,
      content: params.content,
      isPrivate: params.isPrivate,
    );
  }
}

class CreateNoteParams extends Equatable {
  final String title;
  final String content;
  final bool isPrivate;

  const CreateNoteParams({
    required this.title,
    required this.content,
    required this.isPrivate,
  });

  @override
  List<Object?> get props => [title, content, isPrivate];
}
