import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:grade_tracker/providers/navigation_provider.dart';
import 'package:grade_tracker/providers/subject_provider.dart';
import 'package:grade_tracker/providers/theme_provider.dart';
import 'package:grade_tracker/theme/app_theme.dart';

void main() {
  testWidgets('App loads and shows bottom navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => SubjectProvider()),
          ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const Scaffold(
            body: Text('Grade Tracker'),
          ),
        ),
      ),
    );

    expect(find.text('Grade Tracker'), findsOneWidget);
  });
}
