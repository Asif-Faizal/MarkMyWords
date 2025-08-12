import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/note.dart';
import '../models/invite.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';
  late Dio _dio;
  String? _token;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Handle unauthorized access
          _clearToken();
        }
        handler.next(error);
      },
    ));
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    _token = token;
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token = null;
  }

  // Authentication
  Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final response = await _dio.post('/auth/register', data: {
      'email': email,
      'username': username,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
    });

    return response.data;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    final data = response.data;
    if (data['token'] != null) {
      await _saveToken(data['token']);
    }

    return data;
  }

  Future<void> logout() async {
    await _clearToken();
  }

  Future<User> getCurrentUser() async {
    await _loadToken();
    final response = await _dio.get('/auth/me');
    return User.fromJson(response.data['user']);
  }

  // Notes
  Future<List<Note>> getNotes() async {
    await _loadToken();
    final response = await _dio.get('/notes');
    return (response.data['notes'] as List)
        .map((json) => Note.fromJson(json))
        .toList();
  }

  Future<Note> createNote({
    required String title,
    required String content,
    required bool isPrivate,
  }) async {
    await _loadToken();
    final response = await _dio.post('/notes', data: {
      'title': title,
      'content': content,
      'is_private': isPrivate,
    });
    return Note.fromJson(response.data['note']);
  }

  Future<Note> getNote(int id) async {
    await _loadToken();
    final response = await _dio.get('/notes/$id');
    return Note.fromJson(response.data['note']);
  }

  Future<Note> updateNote({
    required int id,
    String? title,
    String? content,
    bool? isPrivate,
  }) async {
    await _loadToken();
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (content != null) data['content'] = content;
    if (isPrivate != null) data['is_private'] = isPrivate;

    final response = await _dio.put('/notes/$id', data: data);
    return Note.fromJson(response.data['note']);
  }

  Future<void> deleteNote(int id) async {
    await _loadToken();
    await _dio.delete('/notes/$id');
  }

  Future<List<Note>> getCollaborativeNotes() async {
    await _loadToken();
    final response = await _dio.get('/notes/collaborative');
    return (response.data['notes'] as List)
        .map((json) => Note.fromJson(json))
        .toList();
  }

  // Invites
  Future<List<Invite>> getInvites() async {
    await _loadToken();
    final response = await _dio.get('/invites');
    return (response.data['invites'] as List)
        .map((json) => Invite.fromJson(json))
        .toList();
  }

  Future<Invite> createInvite({
    required int noteId,
    required int toUserId,
  }) async {
    await _loadToken();
    final response = await _dio.post('/notes/$noteId/invite', data: {
      'to_user_id': toUserId,
    });
    return Invite.fromJson(response.data['invite']);
  }

  Future<void> acceptInvite(int inviteId) async {
    await _loadToken();
    await _dio.post('/invites/$inviteId/accept');
  }

  Future<void> declineInvite(int inviteId) async {
    await _loadToken();
    await _dio.post('/invites/$inviteId/decline');
  }

  // Users
  Future<List<User>> searchUsers(String query) async {
    await _loadToken();
    final response = await _dio.post('/users/search', data: {
      'query': query,
    });
    return (response.data['users'] as List)
        .map((json) => User.fromJson(json))
        .toList();
  }

  bool get isAuthenticated => _token != null;
}
