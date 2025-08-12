import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  });

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, void>> logout();
}
