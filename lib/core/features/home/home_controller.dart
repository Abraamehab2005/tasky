import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/models/task_model.dart';

class HomeController with ChangeNotifier {
  HomeController() {
    init();
  }
  List<TaskModel> taskesList = [];

  String? username = "Default";
  String? userImagePath;
  int totalTask = 0;
  int totalDoneTasks = 0;
  double percent = 0;
  List<TaskModel> tasks = [];
  bool isLoading = false;

  void init() {
    loadTask();
    loadUserName();
  }

  void loadTask() async {
    // isLoading = false;
    final fianlTask = PreferencesManager().getString(StorageKey.tasks);
    if (fianlTask != null) {
      final taskAfterDecode = jsonDecode(fianlTask) as List<dynamic>;

      tasks = taskAfterDecode.map((element) {
        return TaskModel.fromJson(element);
      }).toList();
      calculatePercent();
    }
    // isLoading = true;
    notifyListeners();
  }

  void loadUserName() async {
    username = PreferencesManager().getString(StorageKey.username);
    userImagePath = PreferencesManager().getString(StorageKey.userImage);
    notifyListeners();
  }

  calculatePercent() {
    totalTask = tasks.length;
    totalDoneTasks = tasks.where((e) => e.isDone).length;
    percent = totalTask == 0 ? 0 : totalDoneTasks / totalTask;
    notifyListeners();
  }

  doneTask(bool? value, int? index) async {
    tasks[index!].isDone = value ?? false;
    calculatePercent();
    final updatedTask = tasks.map((element) => element.toJson()).toList();
    await PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    notifyListeners();
  }

  deleteTask(int? id) async {
    if (id == null) return;

    tasks.removeWhere((task) => task.id == id);
    calculatePercent();
    // todo : make shared method
    final updatedTasks = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTasks));
    notifyListeners();
  }
}
