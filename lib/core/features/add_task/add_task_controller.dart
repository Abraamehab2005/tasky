import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:tasky/core/services/hive_storage_manager.dart';

=======
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/services/file_storage_manager.dart';
import 'package:tasky/core/services/preferences_manager.dart';
>>>>>>> 935ab6852fae0f9eef5621c4786029955c714d8e
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

<<<<<<< HEAD
      listTasks.add(model);

      await HiveStorageManager().saveTasks(listTasks);

=======
      listTasks.add(model.toJson());

      await FileStorageManager().saveTasks(listTasks);

      final taskEncode = jsonEncode(listTasks);
      await PreferencesManager().setString(StorageKey.tasks, taskEncode);
>>>>>>> 935ab6852fae0f9eef5621c4786029955c714d8e
      Navigator.of(context).pop(true); // return home screen
    }
  }

  void toggle(bool value) {
    isHighPriorty = value;
    notifyListeners();
  }
}
