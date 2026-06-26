import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/subject_provider.dart';
import '../widgets/subject_tile.dart';

class SubjectListScreen extends StatelessWidget {
  const SubjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          Consumer<SubjectProvider>(
            builder: (context, provider, _) {
              if (provider.subjects.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined),
                  onPressed: () => _showClearAllDialog(context),
                  tooltip: 'Clear All',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<SubjectProvider>(
        builder: (context, provider, _) {
          final subjects = provider.subjects;
          if (subjects.isEmpty) {
            return _buildEmptyState(context);
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return SubjectTile(
                subject: subject,
                onDismissed: () => provider.removeSubject(index),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 80,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Subjects Yet',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first subject from the Add Subject tab',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<NavigationProvider>().setIndex(0),
              icon: const Icon(Icons.add),
              label: const Text('Add Subject'),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Subjects'),
        content: const Text('Are you sure you want to remove all subjects? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<SubjectProvider>().clearAll();
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
