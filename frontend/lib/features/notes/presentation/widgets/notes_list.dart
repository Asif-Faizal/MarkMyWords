import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/notes_state.dart';
import 'note_card.dart';

class NotesList extends StatelessWidget {
  const NotesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        if (state is NotesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NotesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error loading notes',
                  style: TextStyle(fontSize: 18, color: Colors.red[300]),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<NotesBloc>().add(LoadNotes());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is NotesLoaded) {
          if (state.notes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_add, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No notes yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Create your first note!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<NotesBloc>().add(LoadNotes());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                final note = state.notes[index];
                return NoteCard(note: note);
              },
            ),
          );
        }

        return const Center(
          child: Text('No notes available'),
        );
      },
    );
  }
}
