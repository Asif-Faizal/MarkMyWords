import 'package:equatable/equatable.dart';
import '../../domain/entities/thread.dart';

abstract class ThreadsState extends Equatable {
  const ThreadsState();

  @override
  List<Object?> get props => [];
}

class ThreadsInitial extends ThreadsState {}

class ThreadsLoading extends ThreadsState {}

class ThreadsLoaded extends ThreadsState {
  final List<Thread> threads;

  const ThreadsLoaded(this.threads);

  @override
  List<Object?> get props => [threads];
}

class ThreadsError extends ThreadsState {
  final String message;

  const ThreadsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ThreadCreated extends ThreadsState {
  final Thread thread;

  const ThreadCreated(this.thread);

  @override
  List<Object?> get props => [thread];
}

class ThreadUpdated extends ThreadsState {
  final Thread thread;

  const ThreadUpdated(this.thread);

  @override
  List<Object?> get props => [thread];
}

class ThreadDeleted extends ThreadsState {
  final int threadId;

  const ThreadDeleted(this.threadId);

  @override
  List<Object?> get props => [threadId];
}
