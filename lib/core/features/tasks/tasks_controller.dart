import 'package:flutter/material.dart';
import 'package:tasky/core/services/hive_storage_manager.dart';
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

  void _loadTasks() async {
    // isLoading = false;
    tasks = HiveStorageManager().loadTasks();
    _loadData();
    _calculatePercent();

    // isLoading = true;
    notifyListeners();
  }

  void doneTask(bool? value, int id) async {
    final index = tasks.indexWhere((e) => e.id == id);
    tasks[index].isDone = value ?? false;
    _loadData();
    _calculatePercent();
    HiveStorageManager().saveTasks(tasks);
    notifyListeners();
  }

  deleteTask(int? id) async {
    if (id == null) return;
    tasks.removeWhere((e) => e.id == id);

    _loadData();
    _calculatePercent();
    HiveStorageManager().saveTasks(tasks);
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

  clearTasks() {
    _loadTasks();
  }
}
