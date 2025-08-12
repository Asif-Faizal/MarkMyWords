import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notes_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../widgets/notes_list.dart';
import '../widgets/collaborative_notes_list.dart';
import '../widgets/create_note_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesBloc>().add(LoadNotes());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MarkMyWords'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Navigate to invites page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invites coming soon!')),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                context.read<AuthBloc>().add(LogoutRequested());
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          NotesList(),
          CollaborativeNotesList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'My Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Collaborative',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateNoteDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateNoteDialog(),
    );
  }
}
