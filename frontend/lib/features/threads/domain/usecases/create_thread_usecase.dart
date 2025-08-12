import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/thread.dart';
import '../repositories/threads_repository.dart';

class CreateThreadUseCase {
  final ThreadsRepository repository;

  CreateThreadUseCase(this.repository);

  Future<Either<Failure, Thread>> call({
    required String title,
    required String description,
    required bool isPrivate,
  }) async {
    return await repository.createThread(
      title: title,
      description: description,
      isPrivate: isPrivate,
    );
  }
}
