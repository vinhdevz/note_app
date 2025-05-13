class TaskModel {
  int? id;
  final String title;
  final String description;
  final DateTime dateTime;
  final int priority;
  final bool isCompleted; // ✅ Thêm trường này

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.priority,
    this.isCompleted = false, // ✅ Mặc định là false
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0, // ✅ bool -> int
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dateTime: DateTime.parse(map['dateTime']),
      priority: map['priority'],
      isCompleted: map['isCompleted'] == 1, // ✅ int -> bool
    );
  }

  // ✅ Hàm copy để update
  TaskModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dateTime,
    int? priority,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
