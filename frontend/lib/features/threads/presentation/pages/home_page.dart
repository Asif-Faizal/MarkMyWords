import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/threads/presentation/bloc/threads_bloc.dart';
import '../../../../features/threads/presentation/bloc/threads_event.dart';
import '../../../../features/threads/presentation/bloc/threads_state.dart';
import '../widgets/threads_list.dart';
import '../widgets/thread_card.dart';
import '../widgets/create_thread_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<ThreadsBloc>().add(LoadThreads());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MarkMyWords'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Threads'),
            Tab(text: 'Collaborative'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildThreadsTab(),
          _buildCollaborativeTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateThreadDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildThreadsTab() {
    return BlocBuilder<ThreadsBloc, ThreadsState>(
      builder: (context, state) {
        if (state is ThreadsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ThreadsLoaded) {
          return ThreadsList(threads: state.threads);
        } else if (state is ThreadsError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('No threads found'));
      },
    );
  }

  Widget _buildCollaborativeTab() {
    return BlocBuilder<ThreadsBloc, ThreadsState>(
      builder: (context, state) {
        if (state is ThreadsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ThreadsLoaded) {
          final collaborativeThreads = state.threads.where((t) => !t.isPrivate).toList();
          return ThreadsList(threads: collaborativeThreads);
        } else if (state is ThreadsError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('No collaborative threads found'));
      },
    );
  }

  void _showCreateThreadDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreateThreadDialog(),
    );
  }
}
