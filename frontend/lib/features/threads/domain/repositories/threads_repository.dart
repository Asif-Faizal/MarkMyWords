import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/thread.dart';

abstract class ThreadsRepository {
  Future<Either<Failure, List<Thread>>> getThreads();
  Future<Either<Failure, List<Thread>>> getCollaborativeThreads();
  Future<Either<Failure, Thread>> createThread({
    required String title,
    required String description,
    required bool isPrivate,
  });
  Future<Either<Failure, Thread>> getThread(int id);
  Future<Either<Failure, Thread>> updateThread({
    required int id,
    String? title,
    String? description,
    bool? isPrivate,
  });
  Future<Either<Failure, void>> deleteThread(int id);
}
