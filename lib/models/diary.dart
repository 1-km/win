class Diary {
  int? id;
  String content;
  final DateTime createdAt;

  Diary({this.id, required this.content, required this.createdAt});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
