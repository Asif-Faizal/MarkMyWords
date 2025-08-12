import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class GetNoteUseCase {
  final NotesRepository repository;

  GetNoteUseCase({required this.repository});

  Future<Either<Failure, Note>> call(GetNoteParams params) async {
    return await repository.getNote(params.id);
  }
}

class GetNoteParams extends Equatable {
  final int id;

  const GetNoteParams({required this.id});

  @override
  List<Object?> get props => [id];
}
