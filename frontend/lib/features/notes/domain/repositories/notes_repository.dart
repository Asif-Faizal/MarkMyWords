import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/note.dart';

abstract class NotesRepository {
  Future<Either<Failure, List<Note>>> getThreadNotes(int threadId);
  Future<Either<Failure, Note>> createNote({
    required String content,
    required int threadId,
  });
  Future<Either<Failure, Note>> getNote(int id);
  Future<Either<Failure, Note>> updateNote({
    required int id,
    required String content,
  });
  Future<Either<Failure, void>> deleteNote(int id);
}
