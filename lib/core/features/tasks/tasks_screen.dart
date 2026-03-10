import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/widgets/task_list_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<TaskModel> todoTasks = []; //!Remember :just tasks not completed
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
    final fianlTask = PreferencesManager().getString("tasks");
    if (fianlTask != null) {
      final taskAfterDecode = jsonDecode(fianlTask) as List<dynamic>;
      setState(() {
        todoTasks = taskAfterDecode.map((element) {
          return TaskModel.fromJson(element);
        }).toList();
        todoTasks = todoTasks.where((element) => !element.isDone).toList();
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
        todoTasks.removeWhere((task) => task.id == id);
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
          child: Text("To Do Tasks",
              style: Theme.of(context).textTheme.labelSmall),
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
                    tasks: todoTasks,
                    onTap: (bool? value, int? index) async {
                      setState(() {
                        todoTasks[index!].isDone = value ?? false;
                      });

                      final allData = PreferencesManager().getString("tasks");
                      if (allData != null) {
                        List<TaskModel> allDataList =
                            (jsonDecode(allData) as List)
                                .map((element) => TaskModel.fromJson(element))
                                .toList();

                        final newIndex = allDataList
                            .indexWhere((e) => e.id == todoTasks[index!].id);
                        allDataList[newIndex] = todoTasks[index!];

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
