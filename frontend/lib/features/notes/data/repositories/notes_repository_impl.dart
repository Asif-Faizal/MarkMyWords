import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_service.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_remote_data_source.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesRemoteDataSource remoteDataSource;
  final NetworkService networkService;

  NotesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkService,
  });

  @override
  Future<Either<Failure, List<Note>>> getThreadNotes(int threadId) async {
    try {
      final noteModels = await remoteDataSource.getThreadNotes(threadId);
      final notes = noteModels.map((model) => model.toEntity()).toList();
      return Right(notes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> createNote({
    required String content,
    required int threadId,
  }) async {
    try {
      final noteModel = await remoteDataSource.createNote(
        content: content,
        threadId: threadId,
      );
      return Right(noteModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> getNote(int id) async {
    try {
      final noteModel = await remoteDataSource.getNote(id);
      return Right(noteModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> updateNote({
    required int id,
    required String content,
  }) async {
    try {
      final noteModel = await remoteDataSource.updateNote(
        id: id,
        content: content,
      );
      return Right(noteModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(int id) async {
    try {
      await remoteDataSource.deleteNote(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
