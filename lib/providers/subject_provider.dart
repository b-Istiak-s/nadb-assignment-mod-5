import 'package:flutter/foundation.dart';
import '../models/subject.dart';

class SubjectProvider with ChangeNotifier {
  final List<Subject> _subjects = [];

  List<Subject> get subjects => List.unmodifiable(_subjects);

  List<Subject> get passingSubjects =>
      _subjects.where((s) => s.isPassing).toList();

  void addSubject(Subject subject) {
    _subjects.add(subject);
    notifyListeners();
  }

  void removeSubject(int index) {
    if (index >= 0 && index < _subjects.length) {
      _subjects.removeAt(index);
      notifyListeners();
    }
  }

  void updateSubject(int index, Subject subject) {
    if (index >= 0 && index < _subjects.length) {
      _subjects[index] = subject;
      notifyListeners();
    }
  }

  double get averageMark {
    if (_subjects.isEmpty) return 0.0;
    final total = _subjects.fold<int>(0, (sum, s) => sum + s.mark);
    return total / _subjects.length;
  }

  String get overallGrade {
    if (_subjects.isEmpty) return 'N/A';
    final avg = averageMark;
    if (avg >= 80) return 'A';
    if (avg >= 65) return 'B';
    if (avg >= 50) return 'C';
    return 'F';
  }

  int get totalSubjects => _subjects.length;

  int get passingCount => _subjects.where((s) => s.isPassing).length;

  void clearAll() {
    _subjects.clear();
    notifyListeners();
  }
}
