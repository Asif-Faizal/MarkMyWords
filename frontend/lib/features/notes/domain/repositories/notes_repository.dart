import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/note.dart';

abstract class NotesRepository {
  Future<Either<Failure, List<Note>>> getNotes();
  Future<Either<Failure, List<Note>>> getCollaborativeNotes();
  Future<Either<Failure, Note>> createNote({
    required String title,
    required String content,
    required bool isPrivate,
  });
  Future<Either<Failure, Note>> getNote(int id);
  Future<Either<Failure, Note>> updateNote({
    required int id,
    String? title,
    String? content,
    bool? isPrivate,
  });
  Future<Either<Failure, void>> deleteNote(int id);
}
