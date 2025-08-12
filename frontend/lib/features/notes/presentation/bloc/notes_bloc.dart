import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_note_usecase.dart';
import '../../domain/usecases/get_notes_usecase.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final GetThreadNotesUseCase getThreadNotesUseCase;
  final CreateNoteUseCase createNoteUseCase;

  NotesBloc({
    required this.getThreadNotesUseCase,
    required this.createNoteUseCase,
  }) : super(NotesInitial()) {
    on<LoadThreadNotes>(_onLoadThreadNotes);
    on<CreateNote>(_onCreateNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  Future<void> _onLoadThreadNotes(LoadThreadNotes event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    
    final result = await getThreadNotesUseCase(event.threadId);
    result.fold(
      (failure) => emit(NotesError(failure.toString())),
      (notes) => emit(NotesLoaded(notes)),
    );
  }

  Future<void> _onCreateNote(CreateNote event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    
    final result = await createNoteUseCase(
      content: event.content,
      threadId: event.threadId,
    );
    
    result.fold(
      (failure) => emit(NotesError(failure.toString())),
      (note) => emit(NoteCreated(note)),
    );
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    
    // TODO: Implement note update
    emit(const NotesError('Not implemented yet'));
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    
    // TODO: Implement note deletion
    emit(const NotesError('Not implemented yet'));
  }
}
