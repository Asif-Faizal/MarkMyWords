import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class UpdateNoteUseCase {
  final NotesRepository repository;

  UpdateNoteUseCase({required this.repository});

  Future<Either<Failure, Note>> call(UpdateNoteParams params) async {
    return await repository.updateNote(
      id: params.id,
      title: params.title,
      content: params.content,
      isPrivate: params.isPrivate,
    );
  }
}

class UpdateNoteParams extends Equatable {
  final int id;
  final String? title;
  final String? content;
  final bool? isPrivate;

  const UpdateNoteParams({
    required this.id,
    this.title,
    this.content,
    this.isPrivate,
  });

  @override
  List<Object?> get props => [id, title, content, isPrivate];
}
