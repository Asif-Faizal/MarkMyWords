import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/notes/data/datasources/notes_remote_data_source.dart';
import '../../features/notes/data/repositories/notes_repository_impl.dart';
import '../../features/notes/domain/repositories/notes_repository.dart';
import '../../features/notes/domain/usecases/create_note_usecase.dart';
import '../../features/notes/domain/usecases/get_notes_usecase.dart';
import '../../features/notes/presentation/bloc/notes_bloc.dart';
import '../../features/threads/data/datasources/threads_remote_data_source.dart';
import '../../features/threads/data/repositories/threads_repository_impl.dart';
import '../../features/threads/domain/repositories/threads_repository.dart';
import '../../features/threads/domain/usecases/create_thread_usecase.dart';
import '../../features/threads/domain/usecases/get_threads_usecase.dart';
import '../../features/threads/presentation/bloc/threads_bloc.dart';
import '../../features/invites/presentation/bloc/invites_bloc.dart';
import '../network/network_service.dart';
import '../network/websocket_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<NetworkService>(() => NetworkService());
  sl.registerLazySingleton<WebSocketService>(() => WebSocketService());

  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(networkService: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => RegisterUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(repository: sl()));
  sl.registerFactory(() => AuthBloc(
    loginUseCase: sl(),
    registerUseCase: sl(),
    getCurrentUserUseCase: sl(),
    logoutUseCase: sl(),
  ));

  // Threads
  sl.registerLazySingleton<ThreadsRemoteDataSource>(
    () => ThreadsRemoteDataSourceImpl(networkService: sl()),
  );
  sl.registerLazySingleton<ThreadsRepository>(
    () => ThreadsRepositoryImpl(remoteDataSource: sl(), networkService: sl()),
  );
  sl.registerLazySingleton(() => GetThreadsUseCase(sl()));
  sl.registerLazySingleton(() => CreateThreadUseCase(sl()));
  sl.registerFactory(() => ThreadsBloc(
    getThreadsUseCase: sl(),
    createThreadUseCase: sl(),
  ));

  // Notes
  sl.registerLazySingleton<NotesRemoteDataSource>(
    () => NotesRemoteDataSourceImpl(networkService: sl()),
  );
  sl.registerLazySingleton<NotesRepository>(
    () => NotesRepositoryImpl(remoteDataSource: sl(), networkService: sl()),
  );
  sl.registerLazySingleton(() => GetThreadNotesUseCase(sl()));
  sl.registerLazySingleton(() => CreateNoteUseCase(sl()));
  sl.registerFactory(() => NotesBloc(
    getThreadNotesUseCase: sl(),
    createNoteUseCase: sl(),
  ));

  // Invites
  sl.registerFactory(() => InvitesBloc());
}
