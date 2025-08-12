import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_thread_usecase.dart';
import '../../domain/usecases/get_threads_usecase.dart';
import 'threads_event.dart';
import 'threads_state.dart';

class ThreadsBloc extends Bloc<ThreadsEvent, ThreadsState> {
  final GetThreadsUseCase getThreadsUseCase;
  final CreateThreadUseCase createThreadUseCase;

  ThreadsBloc({
    required this.getThreadsUseCase,
    required this.createThreadUseCase,
  }) : super(ThreadsInitial()) {
    on<LoadThreads>(_onLoadThreads);
    on<LoadCollaborativeThreads>(_onLoadCollaborativeThreads);
    on<CreateThread>(_onCreateThread);
    on<UpdateThread>(_onUpdateThread);
    on<DeleteThread>(_onDeleteThread);
  }

  Future<void> _onLoadThreads(LoadThreads event, Emitter<ThreadsState> emit) async {
    emit(ThreadsLoading());
    
    final result = await getThreadsUseCase();
    result.fold(
      (failure) => emit(ThreadsError(failure.toString())),
      (threads) => emit(ThreadsLoaded(threads)),
    );
  }

  Future<void> _onLoadCollaborativeThreads(LoadCollaborativeThreads event, Emitter<ThreadsState> emit) async {
    emit(ThreadsLoading());
    
    // TODO: Implement collaborative threads loading
    emit(const ThreadsError('Not implemented yet'));
  }

  Future<void> _onCreateThread(CreateThread event, Emitter<ThreadsState> emit) async {
    emit(ThreadsLoading());
    
    final result = await createThreadUseCase(
      title: event.title,
      description: event.description,
      isPrivate: event.isPrivate,
    );
    
    result.fold(
      (failure) => emit(ThreadsError(failure.toString())),
      (thread) => emit(ThreadCreated(thread)),
    );
  }

  Future<void> _onUpdateThread(UpdateThread event, Emitter<ThreadsState> emit) async {
    emit(ThreadsLoading());
    
    // TODO: Implement thread update
    emit(const ThreadsError('Not implemented yet'));
  }

  Future<void> _onDeleteThread(DeleteThread event, Emitter<ThreadsState> emit) async {
    emit(ThreadsLoading());
    
    // TODO: Implement thread deletion
    emit(const ThreadsError('Not implemented yet'));
  }
}
