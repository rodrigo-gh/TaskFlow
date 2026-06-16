class TaskModel {
  const TaskModel({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
    this.description,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }
  Map<String, dynamic> toCreateJson() {
    return {'title': title, 'description': description};
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }
}
