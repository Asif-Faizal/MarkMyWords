import 'package:flutter/material.dart';
import '../../domain/entities/thread.dart';
import 'thread_card.dart';

class ThreadsList extends StatelessWidget {
  final List<Thread> threads;

  const ThreadsList({super.key, required this.threads});

  @override
  Widget build(BuildContext context) {
    if (threads.isEmpty) {
      return Center(
        child: Text(
          'No threads found',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: threads.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ThreadCard(thread: threads[index]),
        );
      },
    );
  }
}
