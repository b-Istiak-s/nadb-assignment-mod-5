import 'package:flutter/material.dart';
import '../models/subject.dart';
import 'grade_chip.dart';

class SubjectTile extends StatelessWidget {
  final Subject subject;
  final VoidCallback onDismissed;

  const SubjectTile({
    super.key,
    required this.subject,
    required this.onDismissed,
  });

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradeColor = _getGradeColor(subject.grade);

    return Dismissible(
      key: ValueKey(subject.name + subject.mark.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.delete_outline,
          color: theme.colorScheme.onError,
          size: 28,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Subject'),
            content: Text('Remove "${subject.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (_) => onDismissed(),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: gradeColor.withValues(alpha: 0.15),
            child: Text(
              subject.grade,
              style: TextStyle(
                color: gradeColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          title: Text(
            subject.name,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Text(
                  'Mark: ${subject.mark}/100',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(width: 16),
                GradeChip(
                  grade: subject.grade,
                  minMark: subject.mark,
                  color: gradeColor,
                ),
              ],
            ),
          ),
          trailing: Icon(
            Icons.drag_handle,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
