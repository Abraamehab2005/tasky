import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/models/task_model.dart';

class TasksController extends ChangeNotifier {
  bool isLoading = false;
  List<TaskModel> tasks = [];
  List<TaskModel> completeTasks = [];
  List<TaskModel> todoTasks = [];

  init() {
    _loadTasks();
  }

  void _loadTasks() {
    // isLoading = false;
    final fianlTask = PreferencesManager().getString(StorageKey.tasks);
    if (fianlTask != null) {
      final taskAfterDecode = jsonDecode(fianlTask) as List<dynamic>;

      tasks = taskAfterDecode.map((element) {
        return TaskModel.fromJson(element);
      }).toList();

      todoTasks = tasks.where((element) => !element.isDone).toList();
      //calculatePercent();
    }
    // isLoading = true;
    notifyListeners();
  }

  void doneTask(bool? value, int? index) async {
    if (index == null) return;
    todoTasks[index].isDone = value ?? false;

    final newIndex = tasks.indexWhere((e) => e.id == todoTasks[index].id);
    tasks[newIndex] = todoTasks[index];

    await PreferencesManager().setString(StorageKey.tasks, jsonEncode(tasks));
    _loadTasks();
  }

  deleteTask(int? id) async {
    if (id == null) return;
      tasks.removeWhere((e) => e.id == id);

      todoTasks.removeWhere((task) => task.id == id);

      final updatedTasks = tasks.map((element) => element.toJson()).toList();
      PreferencesManager()
          .setString(StorageKey.tasks, jsonEncode(updatedTasks));
      notifyListeners();
    
  }
}
