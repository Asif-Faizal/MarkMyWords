import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/network/websocket_service.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/get_notes_usecase.dart';
import '../../domain/usecases/create_note_usecase.dart';
import '../../domain/usecases/update_note_usecase.dart';
import '../../domain/usecases/delete_note_usecase.dart';
import '../../domain/usecases/get_note_usecase.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final GetNotesUseCase getNotesUseCase;
  final CreateNoteUseCase createNoteUseCase;
  final UpdateNoteUseCase updateNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;
  final GetNoteUseCase getNoteUseCase;
  final WebSocketService webSocketService;

  NotesBloc({
    required this.getNotesUseCase,
    required this.createNoteUseCase,
    required this.updateNoteUseCase,
    required this.deleteNoteUseCase,
    required this.getNoteUseCase,
    required this.webSocketService,
  }) : super(NotesInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<CreateNote>(_onCreateNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
    on<LoadNote>(_onLoadNote);
    on<JoinNoteSession>(_onJoinNoteSession);
    on<LeaveNoteSession>(_onLeaveNoteSession);
    on<NoteUpdated>(_onNoteUpdated);

    _setupWebSocket();
  }

  void _setupWebSocket() {
    webSocketService.onMessage((data) {
      final type = data['type'] as String;
      final payload = data['payload'] as Map<String, dynamic>;

      if (type == 'note:update') {
        add(NoteUpdated(
          noteId: payload['note_id'] as int,
          content: payload['content'] as String,
          title: payload['title'] as String?,
        ));
      }
    });
  }

  Future<void> _onLoadNotes(
    LoadNotes event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());
    
    final result = await getNotesUseCase();
    
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (notes) => emit(NotesLoaded(notes: notes)),
    );
  }

  Future<void> _onCreateNote(
    CreateNote event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());
    
    final result = await createNoteUseCase(CreateNoteParams(
      title: event.title,
      content: event.content,
      isPrivate: event.isPrivate,
    ));
    
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (note) {
        final currentNotes = state is NotesLoaded ? (state as NotesLoaded).notes : [];
        emit(NotesLoaded(notes: [...currentNotes, note]));
      },
    );
  }

  Future<void> _onUpdateNote(
    UpdateNote event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());
    
    final result = await updateNoteUseCase(UpdateNoteParams(
      id: event.id,
      title: event.title,
      content: event.content,
      isPrivate: event.isPrivate,
    ));
    
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (updatedNote) {
        if (state is NotesLoaded) {
          final currentNotes = (state as NotesLoaded).notes;
          final updatedNotes = currentNotes.map((note) {
            return note.id == updatedNote.id ? updatedNote : note;
          }).toList();
          emit(NotesLoaded(notes: updatedNotes));
        }
      },
    );
  }

  Future<void> _onDeleteNote(
    DeleteNote event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());
    
    final result = await deleteNoteUseCase(DeleteNoteParams(id: event.id));
    
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (_) {
        if (state is NotesLoaded) {
          final currentNotes = (state as NotesLoaded).notes;
          final updatedNotes = currentNotes.where((note) => note.id != event.id).toList();
          emit(NotesLoaded(notes: updatedNotes));
        }
      },
    );
  }

  Future<void> _onLoadNote(
    LoadNote event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());
    
    final result = await getNoteUseCase(GetNoteParams(id: event.id));
    
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (note) => emit(NoteLoaded(note: note)),
    );
  }

  void _onJoinNoteSession(
    JoinNoteSession event,
    Emitter<NotesState> emit,
  ) {
    webSocketService.joinNote(event.noteId);
  }

  void _onLeaveNoteSession(
    LeaveNoteSession event,
    Emitter<NotesState> emit,
  ) {
    webSocketService.leaveNote(event.noteId);
  }

  void _onNoteUpdated(
    NoteUpdated event,
    Emitter<NotesState> emit,
  ) {
    if (state is NotesLoaded) {
      final currentNotes = (state as NotesLoaded).notes;
      final updatedNotes = currentNotes.map((note) {
        if (note.id == event.noteId) {
          return note.copyWith(
            content: event.content,
            title: event.title ?? note.title,
          );
        }
        return note;
      }).toList();
      emit(NotesLoaded(notes: updatedNotes));
    }
  }
}
