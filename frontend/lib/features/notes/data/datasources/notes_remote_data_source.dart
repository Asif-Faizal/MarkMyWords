import '../../../../core/network/network_service.dart';
import '../models/note_model.dart';

abstract class NotesRemoteDataSource {
  Future<List<NoteModel>> getNotes();
  Future<List<NoteModel>> getCollaborativeNotes();
  Future<NoteModel> createNote({
    required String title,
    required String content,
    required bool isPrivate,
  });
  Future<NoteModel> getNote(int id);
  Future<NoteModel> updateNote({
    required int id,
    String? title,
    String? content,
    bool? isPrivate,
  });
  Future<void> deleteNote(int id);
}

class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  final NetworkService networkService;

  NotesRemoteDataSourceImpl({required this.networkService});

  @override
  Future<List<NoteModel>> getNotes() async {
    final response = await networkService.get('/notes');
    final notesData = response.data['notes'];
    if (notesData == null) return [];
    return (notesData as List)
        .map((json) => NoteModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<NoteModel>> getCollaborativeNotes() async {
    final response = await networkService.get('/notes/collaborative');
    final notesData = response.data['notes'];
    if (notesData == null) return [];
    return (notesData as List)
        .map((json) => NoteModel.fromJson(json))
        .toList();
  }

  @override
  Future<NoteModel> createNote({
    required String title,
    required String content,
    required bool isPrivate,
  }) async {
    final response = await networkService.post('/notes', data: {
      'title': title,
      'content': content,
      'is_private': isPrivate,
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
    String? title,
    String? content,
    bool? isPrivate,
  }) async {
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (content != null) data['content'] = content;
    if (isPrivate != null) data['is_private'] = isPrivate;

    final response = await networkService.put('/notes/$id', data: data);
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
