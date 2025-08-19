import 'package:flutter/material.dart';
import '../../domain/entities/thread.dart';

class ThreadCard extends StatelessWidget {
  final Thread thread;

  const ThreadCard({super.key, required this.thread});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          thread.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (thread.description.isNotEmpty)
              Text(
                thread.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  thread.isPrivate ? Icons.lock : Icons.public,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  thread.isPrivate ? 'Private' : 'Public',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  '${thread.notesCount} messages',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Navigate to thread detail page
        },
      ),
    );
  }
}
