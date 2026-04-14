import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/features/tasks/tasks_controller.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/core/components/task_list_widget.dart';

class TodoTasksScreen extends StatelessWidget {
  const TodoTasksScreen({super.key});

  // void _loadTask() async {
  //   // setState(() { // i do not need to load remember this
  //   //   isLoading = true;
  //   // });
  //   final fianlTask = PreferencesManager().getString(StorageKey.tasks);
  //   if (fianlTask != null) {
  //     final taskAfterDecode = jsonDecode(fianlTask) as List<dynamic>;
  //     setState(() {
  //       todoTasks = taskAfterDecode.map((element) {
  //         return TaskModel.fromJson(element);
  //       }).toList();
  //       todoTasks = todoTasks.where((element) => !element.isDone).toList();
  //     });
  //   }
  //   // setState(() {
  //   //   isLoading = false;
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TasksController>(
      create: (_) => TasksController()..init(),
      builder: (context, _) {
        final controller = context.read<TasksController>();
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
                child: controller.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Consumer<TasksController>(
                        builder: (BuildContext context, value, Widget? child) {
                          return TaskListWidget(
                            tasks: value.todoTasks,
                            onTap: (bool? value, int? index) async {
                              controller.doneTask(value, index);
                            },
                            emptyMessage: 'No Task Found',
                            onDelete: (int? id) {
                              controller.deleteTask(id);
                              // _deleteTask(id);
                            },
                            onEdit: () {
                              controller.init();
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
