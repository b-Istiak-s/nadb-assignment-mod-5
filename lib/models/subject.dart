class Subject {
  final String name;
  int _mark;

  Subject({required this.name, required int mark}) : _mark = mark.clamp(0, 100);

  int get mark => _mark;

  set mark(int value) {
    _mark = value.clamp(0, 100);
  }

  String get grade {
    if (_mark >= 80) return 'A';
    if (_mark >= 65) return 'B';
    if (_mark >= 50) return 'C';
    return 'F';
  }

  bool get isPassing => _mark >= 50;

  Subject copyWith({String? name, int? mark}) {
    return Subject(name: name ?? this.name, mark: mark ?? _mark);
  }
}
