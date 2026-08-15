import 'package:hive_ce_flutter/adapters.dart';
part 'task_model.g.dart';
@HiveType(typeId: 0)
class TaskModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String taskName;
  @HiveField(2)
  final String taskDescription;
  @HiveField(3)
  final bool isHighyPriority;
  @HiveField(4)
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
