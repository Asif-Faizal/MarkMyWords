import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class CreateNoteUseCase {
  final NotesRepository repository;

  CreateNoteUseCase(this.repository);

  Future<Either<Failure, Note>> call({
    required String content,
    required int threadId,
  }) async {
    return await repository.createNote(
      content: content,
      threadId: threadId,
    );
  }
}
