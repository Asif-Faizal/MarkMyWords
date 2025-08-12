import 'package:dio/dio.dart';
import '../../../../core/network/network_service.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  });

  Future<UserModel> getCurrentUser();

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkService networkService;

  AuthRemoteDataSourceImpl({required this.networkService});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await networkService.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    final data = response.data;
    if (data['token'] != null) {
      await networkService.saveToken(data['token']);
    }

    return UserModel.fromJson(data['user']);
  }

  @override
  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final response = await networkService.post('/auth/register', data: {
      'email': email,
      'username': username,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
    });

    return UserModel.fromJson(response.data['user']);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await networkService.get('/auth/me');
    return UserModel.fromJson(response.data['user']);
  }

  @override
  Future<void> logout() async {
    await networkService.clearToken();
  }
}
