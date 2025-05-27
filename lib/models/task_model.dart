class TaskModel {
  int? id;
  final String title;
  final String description;
  final DateTime dateTime;
  final int priority;
  final bool isCompleted;
  final int? categoryId; 

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.priority,
    this.isCompleted = false,
    this.categoryId, 
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0,
      'categoryId': categoryId, 
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dateTime: DateTime.parse(map['dateTime']),
      priority: map['priority'],
      isCompleted: map['isCompleted'] == 1,
      categoryId: map['categoryId'], 
    );
  }

  TaskModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dateTime,
    int? priority,
    bool? isCompleted,
    int? categoryId, 
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      categoryId: categoryId ?? this.categoryId, 
    );
  }
}
