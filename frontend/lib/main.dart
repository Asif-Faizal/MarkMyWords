import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/threads/presentation/bloc/threads_bloc.dart';
import 'features/notes/presentation/bloc/notes_bloc.dart';
import 'features/invites/presentation/bloc/invites_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'core/theme/app_theme.dart';
import 'features/threads/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MarkMyWordsApp());
}

class MarkMyWordsApp extends StatelessWidget {
  const MarkMyWordsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()..add(CheckAuthStatus()),
        ),
        BlocProvider<ThreadsBloc>(
          create: (context) => di.sl<ThreadsBloc>(),
        ),
        BlocProvider<NotesBloc>(
          create: (context) => di.sl<NotesBloc>(),
        ),
        BlocProvider<InvitesBloc>(
          create: (context) => di.sl<InvitesBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'MarkMyWords',
        theme: AppTheme.light,
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthChecking) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is AuthAuthenticated) {
          return const HomePage();
        }

        return const LoginPage();
      },
    );
  }
}
