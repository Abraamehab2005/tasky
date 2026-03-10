import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/widgets/task_list_widget.dart';

class HighPriorityScreen extends StatefulWidget {
  const HighPriorityScreen({super.key});

  @override
  State<HighPriorityScreen> createState() => _HighPriorityScreenState();
}

class _HighPriorityScreenState extends State<HighPriorityScreen> {
  List<TaskModel> highPriorityTasks = []; //!Remember :just tasks not completed
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  void _loadTask() async {
    // setState(() { // i do not need to load remember this
    //   isLoading = true;
    // });

    final fianlTask = PreferencesManager().getString('tasks');
    if (fianlTask != null) {
      final taskAfterDecode = jsonDecode(fianlTask) as List<dynamic>;
      setState(() {
        highPriorityTasks = taskAfterDecode.map((element) {
          return TaskModel.fromJson(element);
        }).toList();
        highPriorityTasks = highPriorityTasks
            .where((element) => element.isHighyPriority)
            .toList();
        highPriorityTasks = highPriorityTasks.reversed.toList();
      });
    }
    // setState(() {
    //   isLoading = false;
    // });
  }

  _deleteTask(int? id) async {
    List<TaskModel> tasks = [];
    if (id == null) return;
    final fianlTask = PreferencesManager().getString('tasks');

    if (fianlTask != null) {
      final taskAfterDecode = jsonDecode(fianlTask) as List<dynamic>;
      tasks = taskAfterDecode
          .map((element) => TaskModel.fromJson(element))
          .toList();
      tasks.removeWhere((e) => e.id == id);

      setState(() {
        highPriorityTasks.removeWhere((task) => task.id == id);
      });
      final updatedTasks = tasks.map((element) => element.toJson()).toList();
      PreferencesManager().setString('tasks', jsonEncode(updatedTasks));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'High Priority Tasks',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : TaskListWidget(
                tasks: highPriorityTasks,
                onTap: (bool? value, int? index) async {
                  setState(() {
                    highPriorityTasks[index!].isDone = value ?? false;
                  });

                  final allData = PreferencesManager().getString("tasks");

                  if (allData != null) {
                    List<TaskModel> allDataList = (jsonDecode(allData) as List)
                        .map((element) => TaskModel.fromJson(element))
                        .toList();

                    final newIndex = allDataList.indexWhere(
                        (e) => e.id == highPriorityTasks[index!].id);
                    allDataList[newIndex] = highPriorityTasks[index!];
                    await PreferencesManager()
                        .setString("tasks", jsonEncode(allDataList));

                    _loadTask();
                  }
                },
                emptyMessage: 'No Task Found',
                onDelete: (int? id) {
                  _deleteTask(id);
                },
                onEdit: () {
                  _loadTask();
                },
              ),
      ),
    );
  }
}
