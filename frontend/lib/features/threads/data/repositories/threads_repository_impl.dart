import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_service.dart';
import '../../domain/entities/thread.dart';
import '../../domain/repositories/threads_repository.dart';
import '../datasources/threads_remote_data_source.dart';

class ThreadsRepositoryImpl implements ThreadsRepository {
  final ThreadsRemoteDataSource remoteDataSource;
  final NetworkService networkService;

  ThreadsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkService,
  });

  @override
  Future<Either<Failure, List<Thread>>> getThreads() async {
    try {
      final threadModels = await remoteDataSource.getThreads();
      final threads = threadModels.map((model) => model.toEntity()).toList();
      return Right(threads);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Thread>>> getCollaborativeThreads() async {
    try {
      final threadModels = await remoteDataSource.getCollaborativeThreads();
      final threads = threadModels.map((model) => model.toEntity()).toList();
      return Right(threads);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Thread>> createThread({
    required String title,
    required String description,
    required bool isPrivate,
  }) async {
    try {
      final threadModel = await remoteDataSource.createThread(
        title: title,
        description: description,
        isPrivate: isPrivate,
      );
      return Right(threadModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Thread>> getThread(int id) async {
    try {
      final threadModel = await remoteDataSource.getThread(id);
      return Right(threadModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Thread>> updateThread({
    required int id,
    String? title,
    String? description,
    bool? isPrivate,
  }) async {
    try {
      final threadModel = await remoteDataSource.updateThread(
        id: id,
        title: title,
        description: description,
        isPrivate: isPrivate,
      );
      return Right(threadModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteThread(int id) async {
    try {
      await remoteDataSource.deleteThread(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
