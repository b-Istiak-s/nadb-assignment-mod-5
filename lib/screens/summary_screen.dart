import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subject_provider.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary', style: theme.textTheme.titleLarge),
      ),
      body: Consumer<SubjectProvider>(
        builder: (context, provider, _) {
          final hasSubjects = provider.subjects.isNotEmpty;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildGradeOverviewCard(context, provider, hasSubjects),
                const SizedBox(height: 16),
                _buildStatsCard(context, provider, hasSubjects),
                const SizedBox(height: 16),
                _buildPassingBreakdown(context, provider, hasSubjects),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGradeOverviewCard(
      BuildContext context, SubjectProvider provider, bool hasSubjects) {
    final theme = Theme.of(context);
    final grade = hasSubjects ? provider.overallGrade : 'N/A';
    final gradeColor = _getGradeColor(grade);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Text('Overall Grade', style: theme.textTheme.titleLarge),
            const SizedBox(height: 24),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: gradeColor.withValues(alpha: 0.15),
                border: Border.all(
                  color: gradeColor.withValues(alpha: 0.5),
                  width: 4,
                ),
              ),
              child: Center(
                child: Text(
                  grade,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: gradeColor,
                  ),
                ),
              ),
            ),
            if (hasSubjects) ...[
              const SizedBox(height: 16),
              Text(
                '${provider.averageMark.toStringAsFixed(1)}% Average',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(
      BuildContext context, SubjectProvider provider, bool hasSubjects) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Statistics', style: theme.textTheme.titleLarge),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    icon: Icons.book_outlined,
                    label: 'Total Subjects',
                    value: '${provider.totalSubjects}',
                    iconColor: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    context,
                    icon: Icons.grade_outlined,
                    label: 'Average Mark',
                    value: hasSubjects
                        ? provider.averageMark.toStringAsFixed(1)
                        : '-',
                    iconColor: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    icon: Icons.check_circle_outline,
                    label: 'Passing',
                    value: '${provider.passingCount}',
                    iconColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    context,
                    icon: Icons.cancel_outlined,
                    label: 'Failing',
                    value: '${provider.totalSubjects - provider.passingCount}',
                    iconColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassingBreakdown(
      BuildContext context, SubjectProvider provider, bool hasSubjects) {
    final theme = Theme.of(context);
    if (!hasSubjects) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No Data Available',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add subjects to see your summary',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final passingSubjects = provider.passingSubjects;
    final failingSubjects =
        provider.subjects.where((s) => !s.isPassing).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Subject Breakdown', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Text(
              'Passing Subjects (${passingSubjects.length})',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 16,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            if (passingSubjects.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No passing subjects yet',
                  style: theme.textTheme.bodyMedium,
                ),
              )
            else
              ...passingSubjects.map(
                (s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          size: 18, color: Colors.green),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${s.name} - ${s.mark} (${s.grade})',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const Divider(height: 32),
            Text(
              'Failing Subjects (${failingSubjects.length})',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            if (failingSubjects.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No failing subjects',
                  style: theme.textTheme.bodyMedium,
                ),
              )
            else
              ...failingSubjects.map(
                (s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.cancel, size: 18, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${s.name} - ${s.mark} (${s.grade})',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      case 'N/A':
        return Colors.grey;
      default:
        return Colors.red;
    }
  }
}
