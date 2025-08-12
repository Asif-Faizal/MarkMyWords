import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/threads/presentation/bloc/threads_bloc.dart';
import '../../../../features/threads/presentation/bloc/threads_event.dart';

class CreateThreadDialog extends StatefulWidget {
  const CreateThreadDialog({super.key});

  @override
  State<CreateThreadDialog> createState() => _CreateThreadDialogState();
}

class _CreateThreadDialogState extends State<CreateThreadDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPrivate = true;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Thread'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isPrivate,
                  onChanged: (value) {
                    setState(() {
                      _isPrivate = value ?? true;
                    });
                  },
                ),
                const Text('Private thread'),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createThread,
          child: const Text('Create'),
        ),
      ],
    );
  }

  void _createThread() {
    if (_formKey.currentState!.validate()) {
      context.read<ThreadsBloc>().add(
        CreateThread(
          title: _titleController.text,
          description: _descriptionController.text,
          isPrivate: _isPrivate,
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
