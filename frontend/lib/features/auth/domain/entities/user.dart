import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, email, username, firstName, lastName, createdAt];
}
