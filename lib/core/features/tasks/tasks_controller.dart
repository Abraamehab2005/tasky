import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/models/task_model.dart';

class TasksController extends ChangeNotifier {
  bool isLoading = false;
  int totalTask = 0;
  int totalDoneTasks = 0;
  double percent = 0;

  List<TaskModel> tasks = [];
  List<TaskModel> completeTasks = [];
  List<TaskModel> todoTasks = [];
  List<TaskModel> highPriorityTasks = [];

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

      _loadData();

      _calculatePercent();
    }
    // isLoading = true;
    notifyListeners();
  }

  void doneTask(bool? value, int id) async {
    final index = tasks.indexWhere((e) => e.id == id);
    tasks[index].isDone = value ?? false;
    _loadData();
    _calculatePercent();

    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    notifyListeners();
  }
  deleteTask(int? id) async {
    if (id == null) return;
    tasks.removeWhere((e) => e.id == id);

    _loadData();
    _calculatePercent();

    final updatedTasks = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTasks));

    notifyListeners();
  }

  _calculatePercent() {
    totalTask = tasks.length;
    totalDoneTasks = tasks.where((e) => e.isDone).length;
    percent = totalTask == 0 ? 0 : totalDoneTasks / totalTask;
    notifyListeners();
  }

  void _loadData() {
    todoTasks = tasks.where((element) => !element.isDone).toList();
    completeTasks = tasks.where((element) => element.isDone == true).toList();

    highPriorityTasks =
        tasks.where((element) => element.isHighyPriority).toList();
    highPriorityTasks = highPriorityTasks.reversed.toList();
  }
}
