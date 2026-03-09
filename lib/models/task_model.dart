class TaskModel {
  final int id;
  final String taskName;
  final String taskDescription;
  final bool isHighyPriority;
  bool isDone;
  TaskModel({
    required this.id,
    required this.taskName,
    required this.taskDescription,
    required this.isHighyPriority,
    this.isDone = false,
  });
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
        id: json["id"],
        taskName: json["taskName"],
        taskDescription: json["taskDescription"],
        isHighyPriority: json["isHighyPriority"],
        isDone: json["isDone"] ?? false);
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "taskName": taskName,
      "taskDescription": taskDescription,
      "isHighyPriority": isHighyPriority,
      "isDone": isDone
    };
  }
}
