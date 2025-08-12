import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
      email: params.email,
      username: params.username,
      password: params.password,
      firstName: params.firstName,
      lastName: params.lastName,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String username;
  final String password;
  final String firstName;
  final String lastName;

  const RegisterParams({
    required this.email,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [email, username, password, firstName, lastName];
}
