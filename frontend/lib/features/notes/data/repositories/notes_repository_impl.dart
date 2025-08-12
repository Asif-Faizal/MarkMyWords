import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_remote_data_source.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesRemoteDataSource remoteDataSource;

  NotesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Note>>> getNotes() async {
    try {
      final noteModels = await remoteDataSource.getNotes();
      return Right(noteModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getCollaborativeNotes() async {
    try {
      final noteModels = await remoteDataSource.getCollaborativeNotes();
      return Right(noteModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> createNote({
    required String title,
    required String content,
    required bool isPrivate,
  }) async {
    try {
      final noteModel = await remoteDataSource.createNote(
        title: title,
        content: content,
        isPrivate: isPrivate,
      );
      return Right(noteModel.toEntity());
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> getNote(int id) async {
    try {
      final noteModel = await remoteDataSource.getNote(id);
      return Right(noteModel.toEntity());
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> updateNote({
    required int id,
    String? title,
    String? content,
    bool? isPrivate,
  }) async {
    try {
      final noteModel = await remoteDataSource.updateNote(
        id: id,
        title: title,
        content: content,
        isPrivate: isPrivate,
      );
      return Right(noteModel.toEntity());
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(int id) async {
    try {
      await remoteDataSource.deleteNote(id);
      return const Right(null);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
