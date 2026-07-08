import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_size.dart';

import 'package:tasky/core/features/tasks/tasks_controller.dart';

import 'package:tasky/core/components/task_list_widget.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(AppSize.pw18),
          child: Text(
            "Completed Tasks",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(AppSize.pw16),
            child: controller.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Consumer<TasksController>(
                    builder:
                        (BuildContext context, valueController, Widget? child) {
                      return TaskListWidget(
                        tasks: valueController.completeTasks,
                        onTap: (bool? value, int? index) async {
                          controller.doneTask(
                              value, valueController.completeTasks[index!].id);
                        },
                        emptyMessage: 'No Task Found',
                        onDelete: (int? id) {
                          controller.deleteTask(id);
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
  }
}
