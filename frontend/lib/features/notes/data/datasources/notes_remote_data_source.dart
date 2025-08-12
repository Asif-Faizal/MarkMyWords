import '../../../../core/network/network_service.dart';
import '../models/note_model.dart';

abstract class NotesRemoteDataSource {
  Future<List<NoteModel>> getThreadNotes(int threadId);
  Future<NoteModel> createNote({
    required String content,
    required int threadId,
  });
  Future<NoteModel> getNote(int id);
  Future<NoteModel> updateNote({
    required int id,
    required String content,
  });
  Future<void> deleteNote(int id);
}

class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  final NetworkService networkService;

  NotesRemoteDataSourceImpl({required this.networkService});

  @override
  Future<List<NoteModel>> getThreadNotes(int threadId) async {
    final response = await networkService.get('/notes/thread/$threadId');
    final notesData = response.data['notes'];
    if (notesData == null) return [];
    return (notesData as List)
        .map((json) => NoteModel.fromJson(json))
        .toList();
  }

  @override
  Future<NoteModel> createNote({
    required String content,
    required int threadId,
  }) async {
    final response = await networkService.post('/notes', data: {
      'content': content,
      'thread_id': threadId,
    });
    final noteData = response.data['note'];
    if (noteData == null) {
      throw Exception('Note data is null');
    }
    return NoteModel.fromJson(noteData);
  }

  @override
  Future<NoteModel> getNote(int id) async {
    final response = await networkService.get('/notes/$id');
    final noteData = response.data['note'];
    if (noteData == null) {
      throw Exception('Note data is null');
    }
    return NoteModel.fromJson(noteData);
  }

  @override
  Future<NoteModel> updateNote({
    required int id,
    required String content,
  }) async {
    final response = await networkService.put('/notes/$id', data: {
      'content': content,
    });
    final noteData = response.data['note'];
    if (noteData == null) {
      throw Exception('Note data is null');
    }
    return NoteModel.fromJson(noteData);
  }

  @override
  Future<void> deleteNote(int id) async {
    await networkService.delete('/notes/$id');
  }
}
