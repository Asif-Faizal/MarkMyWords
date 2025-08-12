import '../../../../core/network/network_service.dart';
import '../models/thread_model.dart';

abstract class ThreadsRemoteDataSource {
  Future<List<ThreadModel>> getThreads();
  Future<List<ThreadModel>> getCollaborativeThreads();
  Future<ThreadModel> createThread({
    required String title,
    required String description,
    required bool isPrivate,
  });
  Future<ThreadModel> getThread(int id);
  Future<ThreadModel> updateThread({
    required int id,
    String? title,
    String? description,
    bool? isPrivate,
  });
  Future<void> deleteThread(int id);
}

class ThreadsRemoteDataSourceImpl implements ThreadsRemoteDataSource {
  final NetworkService networkService;

  ThreadsRemoteDataSourceImpl({required this.networkService});

  @override
  Future<List<ThreadModel>> getThreads() async {
    final response = await networkService.get('/threads');
    final threadsData = response.data['threads'];
    if (threadsData == null) return [];
    return (threadsData as List)
        .map((json) => ThreadModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<ThreadModel>> getCollaborativeThreads() async {
    final response = await networkService.get('/threads/collaborative');
    final threadsData = response.data['threads'];
    if (threadsData == null) return [];
    return (threadsData as List)
        .map((json) => ThreadModel.fromJson(json))
        .toList();
  }

  @override
  Future<ThreadModel> createThread({
    required String title,
    required String description,
    required bool isPrivate,
  }) async {
    final response = await networkService.post('/threads', data: {
      'title': title,
      'description': description,
      'is_private': isPrivate,
    });
    final threadData = response.data['thread'];
    if (threadData == null) {
      throw Exception('Thread data is null');
    }
    return ThreadModel.fromJson(threadData);
  }

  @override
  Future<ThreadModel> getThread(int id) async {
    final response = await networkService.get('/threads/$id');
    final threadData = response.data['thread'];
    if (threadData == null) {
      throw Exception('Thread data is null');
    }
    return ThreadModel.fromJson(threadData);
  }

  @override
  Future<ThreadModel> updateThread({
    required int id,
    String? title,
    String? description,
    bool? isPrivate,
  }) async {
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (isPrivate != null) data['is_private'] = isPrivate;

    final response = await networkService.put('/threads/$id', data: data);
    final threadData = response.data['thread'];
    if (threadData == null) {
      throw Exception('Thread data is null');
    }
    return ThreadModel.fromJson(threadData);
  }

  @override
  Future<void> deleteThread(int id) async {
    await networkService.delete('/threads/$id');
  }
}
