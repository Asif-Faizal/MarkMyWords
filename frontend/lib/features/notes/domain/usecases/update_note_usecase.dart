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
      content: params.content,
    );
  }
}

class UpdateNoteParams extends Equatable {
  final int id;
  final String content;

  const UpdateNoteParams({
    required this.id,
    required this.content,
  });

  @override
  List<Object?> get props => [id, content];
}
