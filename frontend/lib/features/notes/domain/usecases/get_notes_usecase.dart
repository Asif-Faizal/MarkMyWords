import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class GetNotesUseCase {
  final NotesRepository repository;

  GetNotesUseCase({required this.repository});

  Future<Either<Failure, List<Note>>> call() async {
    return await repository.getNotes();
  }
}
