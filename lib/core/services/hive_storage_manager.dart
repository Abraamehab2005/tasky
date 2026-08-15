import 'dart:convert';
import 'dart:io';

import 'package:hive_ce_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasky/core/constants/constans.dart';
import 'package:tasky/models/task_model.dart';

class HiveStorageManager {
  static final HiveStorageManager _instance = HiveStorageManager._();

  HiveStorageManager._();
  factory HiveStorageManager() {
    return _instance;
  }
  late Box<TaskModel> _taskBox;
  init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskModelAdapter());
    _taskBox = await Hive.openBox<TaskModel>(Constans.tasksNameCollection);
  }

  saveTasks(List<TaskModel> List) async {
    await _taskBox.clear();
    await _taskBox.addAll(List);
  }

  List<TaskModel> loadTasks() {
    return _taskBox.values.toList();
  }

  clear() async {
    await _taskBox.clear();
  }
}
