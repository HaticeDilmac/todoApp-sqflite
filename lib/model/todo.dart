class ToDo {
  final int id;
  final String title;
  final String createdTime;
  final String? updatedTime;

  ToDo({
    required this.id,
    required this.title,
    required this.createdTime,
    this.updatedTime,
  });

  factory ToDo.fromSqfliteDatabase(Map<String, dynamic> map) => ToDo(
        id: map['id'] ?? 0,
        title: map['title'] ?? '',
        createdTime: map['created_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['created_at'])
                .toIso8601String()
            : '',
        updatedTime: map['updated_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
                .toIso8601String()
            : null,
      );
}
