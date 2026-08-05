import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/services/file_storage_manager.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/models/task_model.dart';

class AddTaskController extends ChangeNotifier {
  bool isHighPriorty = true;

  //!TODO : DISPOSE THIS CONTROLLERS
  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController taskDescriptionController =
      TextEditingController();

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  void AddTask(BuildContext context) async {
    if (key.currentState?.validate() ?? false) {
     List<dynamic> listTasks = await FileStorageManager().loadTasks();

      TaskModel model = TaskModel(
        id: listTasks.length + 1,
        taskName: taskNameController.text,
        taskDescription: taskDescriptionController.text,
        isHighyPriority: isHighPriorty,
      );

      listTasks.add(model.toJson());

      await FileStorageManager().saveTasks(listTasks);


      Navigator.of(context).pop(true); // return home screen
    }
  }

  void toggle(bool value) {
    isHighPriorty = value;
    notifyListeners();
  }
}
