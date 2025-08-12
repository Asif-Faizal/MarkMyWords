import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/notes_state.dart';

class CollaborativeNotesList extends StatelessWidget {
  const CollaborativeNotesList({super.key});

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
                  'Error loading collaborative notes',
                  style: TextStyle(fontSize: 18, color: Colors.red[300]),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // For now, show a placeholder since we haven't implemented collaborative notes loading
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No collaborative notes',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'You haven\'t been invited to any notes yet',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
