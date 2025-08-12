import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/thread.dart';
import '../repositories/threads_repository.dart';

class GetThreadsUseCase {
  final ThreadsRepository repository;

  GetThreadsUseCase(this.repository);

  Future<Either<Failure, List<Thread>>> call() async {
    return await repository.getThreads();
  }
}
