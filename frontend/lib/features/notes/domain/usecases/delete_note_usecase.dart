import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/notes_repository.dart';

class DeleteNoteUseCase {
  final NotesRepository repository;

  DeleteNoteUseCase({required this.repository});

  Future<Either<Failure, void>> call(DeleteNoteParams params) async {
    return await repository.deleteNote(params.id);
  }
}

class DeleteNoteParams extends Equatable {
  final int id;

  const DeleteNoteParams({required this.id});

  @override
  List<Object?> get props => [id];
}
