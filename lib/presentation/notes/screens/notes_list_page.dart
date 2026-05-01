import 'package:academic_project/presentation/auth/provider/auth_provider.dart';
import 'package:academic_project/presentation/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:academic_project/presentation/navigation/routes.dart';
import 'package:academic_project/presentation/notes/provider/notes_provider.dart';

class NotesListPage extends ConsumerWidget {
  const NotesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesState = ref.watch(notesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => ref.read(authProvider.notifier).logout(),
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/'),
      body: notesState.when(
        data: (notes) {
          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_alt_outlined,
                    size: 80,
                    color: theme.primaryColor.withOpacity(0.2),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notes yet',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                  Text(
                    'Start by adding your first study note!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white30,
                    ),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return _NoteCard(note: note, ref: ref)
                    .animate()
                    .fadeIn(delay: (index * 50).ms)
                    .scale(begin: const Offset(0.95, 0.95));
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddNoteDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Note'),
        backgroundColor: theme.primaryColor,
      ).animate().scale(delay: 500.ms, curve: Curves.easeOutBack),
    );
  }

  void _showAddNoteDialog(BuildContext context, WidgetRef ref) {
    final contentController = TextEditingController();
    final subjectController = TextEditingController();
    final topicController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Study Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                hintText: 'e.g. Mathematics',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: topicController,
              decoration: const InputDecoration(
                labelText: 'Topic',
                hintText: 'e.g. Calculus',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Summary/Content'),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Discard'),
          ),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(notesProvider.notifier)
                  .addNote(
                    contentController.text,
                    subjectController.text,
                    topicController.text,
                  );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(100, 45)),
            child: const Text('Save Note'),
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final dynamic note;
  final WidgetRef ref;

  const _NoteCard({required this.note, required this.ref});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      note.subject,
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      note.bookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: note.bookmarked
                          ? theme.primaryColor
                          : Colors.white24,
                    ),
                    onPressed: () => ref
                        .read(notesProvider.notifier)
                        .toggleBookmark(note.id),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                note.topic,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  note.content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white54,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Last updated: Just now',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
