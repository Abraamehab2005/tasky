import 'package:flutter/material.dart';
import 'package:tasky/core/services/hive_storage_manager.dart';

import 'package:tasky/models/task_model.dart';

class AddTaskController extends ChangeNotifier {
  bool isHighPriorty = true;

  //!TODO : DISPOSE THIS CONTROLLERS
  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController taskDescriptionController =
      TextEditingController();

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  void addTask(BuildContext context) async {
    if (key.currentState?.validate() ?? false) {
      List<TaskModel> listTasks = HiveStorageManager().loadTasks();

      TaskModel model = TaskModel(
        id: listTasks.length + 1,
        taskName: taskNameController.text,
        taskDescription: taskDescriptionController.text,
        isHighyPriority: isHighPriorty,
      );

      listTasks.add(model);

      await HiveStorageManager().saveTasks(listTasks);

      Navigator.of(context).pop(true); // return home screen
    }
  }

  void toggle(bool value) {
    isHighPriorty = value;
    notifyListeners();
  }
}
