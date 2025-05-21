class CategoryModel {
  final int? id;
  final String label;
  final String icon; // đường dẫn asset icon
  final int color;   // lưu dưới dạng int (Color.value)

  CategoryModel({
    this.id,
    required this.label,
    required this.icon,
    required this.color,
  });

  CategoryModel copyWith({
    int? id,
    String? label,
    String? icon,
    int? color,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'icon': icon,
      'color': color,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      label: map['label'] as String,
      icon: map['icon'] as String,
      color: map['color'] as int,
    );
  }
}
