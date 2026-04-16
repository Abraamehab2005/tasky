

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

  bool isLoading = false;

  void init() {
    loadUserData();
  }

  void loadUserData() async {
    username = PreferencesManager().getString(StorageKey.username);
    userImagePath = PreferencesManager().getString(StorageKey.userImage);
    notifyListeners();
  }
}
