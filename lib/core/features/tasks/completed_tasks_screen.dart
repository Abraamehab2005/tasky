import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/core/components/task_list_widget.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  List<TaskModel> completeTasks = [];
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
        completeTasks = taskAfterDecode.map((element) {
          return TaskModel.fromJson(element);
        }).toList();
        completeTasks =
            completeTasks.where((element) => element.isDone == true).toList();
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
        completeTasks.removeWhere((task) => task.id == id);
      });
      final updatedTasks = tasks.map((element) => element.toJson()).toList();
      PreferencesManager().setString('tasks', jsonEncode(updatedTasks));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            "Completed Tasks",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : TaskListWidget(
                    tasks: completeTasks,
                    onTap: (bool? value, int? index) async {
                      setState(() {
                        completeTasks[index!].isDone = value ?? false;
                      });

                      final allData = PreferencesManager().getString("tasks");

                      if (allData != null) {
                        List<TaskModel> allDataList =
                            (jsonDecode(allData) as List)
                                .map((element) => TaskModel.fromJson(element))
                                .toList();

                        final newIndex = allDataList.indexWhere(
                            (e) => e.id == completeTasks[index!].id);
                        allDataList[newIndex] = completeTasks[index!];
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
        ),
      ],
    );
  }
}
