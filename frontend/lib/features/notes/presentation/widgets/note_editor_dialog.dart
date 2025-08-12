import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/note.dart';
import '../bloc/notes_bloc.dart';

class NoteEditorDialog extends StatefulWidget {
  final Note? note;

  const NoteEditorDialog({super.key, this.note});

  @override
  State<NoteEditorDialog> createState() => _NoteEditorDialogState();
}

class _NoteEditorDialogState extends State<NoteEditorDialog> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isPrivate = true;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _isPrivate = widget.note!.isPrivate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.note == null ? 'Create Note' : 'Edit Note',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Private Note'),
                const SizedBox(width: 8),
                Switch(
                  value: _isPrivate,
                  onChanged: (value) {
                    setState(() {
                      _isPrivate = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveNote,
                  child: Text(widget.note == null ? 'Create' : 'Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveNote() {
    if (widget.note == null) {
      // Create new note
      context.read<NotesBloc>().add(CreateNote(
        title: _titleController.text,
        content: _contentController.text,
        isPrivate: _isPrivate,
      ));
    } else {
      // Update existing note
      context.read<NotesBloc>().add(UpdateNote(
        id: widget.note!.id,
        title: _titleController.text,
        content: _contentController.text,
        isPrivate: _isPrivate,
      ));
    }
    Navigator.pop(context);
  }
}

class CreateNoteDialog extends StatelessWidget {
  const CreateNoteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const NoteEditorDialog();
  }
}
