import 'package:get_it/get_it.dart';
import '../network/network_service.dart';
import '../network/websocket_service.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/notes/data/datasources/notes_remote_data_source.dart';
import '../../features/notes/data/repositories/notes_repository_impl.dart';
import '../../features/notes/domain/repositories/notes_repository.dart';
import '../../features/notes/domain/usecases/get_notes_usecase.dart';
import '../../features/notes/domain/usecases/create_note_usecase.dart';
import '../../features/notes/domain/usecases/update_note_usecase.dart';
import '../../features/notes/domain/usecases/delete_note_usecase.dart';
import '../../features/notes/domain/usecases/get_note_usecase.dart';
import '../../features/notes/presentation/bloc/notes_bloc.dart';
import '../../features/invites/data/datasources/invites_remote_data_source.dart';
import '../../features/invites/data/repositories/invites_repository_impl.dart';
import '../../features/invites/domain/repositories/invites_repository.dart';
import '../../features/invites/domain/usecases/get_invites_usecase.dart';
import '../../features/invites/domain/usecases/accept_invite_usecase.dart';
import '../../features/invites/domain/usecases/decline_invite_usecase.dart';
import '../../features/invites/presentation/bloc/invites_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<NetworkService>(() => NetworkService());
  sl.registerLazySingleton<WebSocketService>(() => WebSocketService());

  // Auth Feature
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

  // Notes Feature
  sl.registerLazySingleton<NotesRemoteDataSource>(
    () => NotesRemoteDataSourceImpl(networkService: sl()),
  );
  sl.registerLazySingleton<NotesRepository>(
    () => NotesRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetNotesUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateNoteUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateNoteUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteNoteUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetNoteUseCase(repository: sl()));
  sl.registerFactory(() => NotesBloc(
    getNotesUseCase: sl(),
    createNoteUseCase: sl(),
    updateNoteUseCase: sl(),
    deleteNoteUseCase: sl(),
    getNoteUseCase: sl(),
    webSocketService: sl(),
  ));

  // Invites Feature
  sl.registerLazySingleton<InvitesRemoteDataSource>(
    () => InvitesRemoteDataSourceImpl(networkService: sl()),
  );
  sl.registerLazySingleton<InvitesRepository>(
    () => InvitesRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetInvitesUseCase(repository: sl()));
  sl.registerLazySingleton(() => AcceptInviteUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeclineInviteUseCase(repository: sl()));
  sl.registerFactory(() => InvitesBloc(
    getInvitesUseCase: sl(),
    acceptInviteUseCase: sl(),
    declineInviteUseCase: sl(),
  ));
}
