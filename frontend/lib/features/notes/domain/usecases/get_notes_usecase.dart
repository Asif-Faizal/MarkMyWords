import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class GetThreadNotesUseCase {
  final NotesRepository repository;

  GetThreadNotesUseCase(this.repository);

  Future<Either<Failure, List<Note>>> call(int threadId) async {
    return await repository.getThreadNotes(threadId);
  }
}
