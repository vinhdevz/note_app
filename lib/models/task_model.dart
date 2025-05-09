class TaskModel {
  int? id; // ID tự tăng để lưu trong SQLite
  final String title;
  final String description;
  final DateTime dateTime;
  final int priority;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.priority,
  });

  // Chuyển thành Map để lưu
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'priority': priority,
    };
  }

  // Tạo từ Map khi lấy từ DB
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dateTime: DateTime.parse(map['dateTime']),
      priority: map['priority'],
    );
  }
}
