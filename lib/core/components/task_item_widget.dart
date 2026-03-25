import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/enum/task_item_actions_enam.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custom_check_box.dart';
import 'package:tasky/core/widgets/custom_text_form_field.dart';
import 'package:tasky/models/task_model.dart';

class TaskItemWidget extends StatelessWidget {
  const TaskItemWidget(
      {super.key,
      required this.model,
      required this.onChanged,
      required this.onDelete,
      required this.onEdit});
  final TaskModel model;
  final Function(bool?) onChanged;
  final Function(int) onDelete;
  final Function onEdit;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color: ThemeController.isDark()
              ? Colors.transparent
              : Color(
                  0xFFD1DAD6,
                ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 8,
          ),
          CustomCheckBox(
            value: model.isDone,
            onChanged: (bool? value) {
              onChanged(value);
            },
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.taskName,
                  style: model.isDone
                      ? Theme.of(context).textTheme.titleLarge
                      : Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                ),
                if (model.taskDescription.isNotEmpty)
                  Text(
                    model.taskDescription,
                    style: TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      color: ThemeController.isDark()
                          ? Color(0xFFC6C6C6)
                          : Color(0xFF3A4640),
                    ),
                    maxLines: 1,
                  ),
              ],
            ),
          ),
          PopupMenuButton<TaskItemActionsEnam>(
              onSelected: (value) async {
                switch (value) {
                  case TaskItemActionsEnam.markAsDone:
                    onChanged(!model.isDone);
                  case TaskItemActionsEnam.delete:
                    await _showAlertDialog(context);

                  case TaskItemActionsEnam.edit:
                    final result = await _showButtonSheet(context, model);
                    if (result == true) {
                      onEdit();
                    }
                }
              },
              icon: Icon(
                Icons.more_vert,
                color: ThemeController.isDark()
                    ? (model.isDone ? Color(0xFFA0A0A0) : Color(0xFFFFFCFC))
                    : (model.isDone ? Color(0xFF6A6A6A) : Color(0xFF3A4640)),
              ),
              itemBuilder: (context) {
                return TaskItemActionsEnam.values.map((e) {
                  return PopupMenuItem(
                    value: e,
                    child: Text(
                      e.name,
                    ),
                  );
                }).toList();
              }),
        ],
      ),
    );
  }

  Future _showAlertDialog(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Delete Task',
            ),
            content: Text(
              "Are you sure you want to delete this task?",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                ),
              ),
              TextButton(
                onPressed: () {
                  onDelete(model.id);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: Text(
                  "Delete",
                ),
              ),
            ],
          );
        });
  }
}

Future<bool?> _showButtonSheet(context, TaskModel model) {
  TextEditingController taskNameController =
      TextEditingController(text: model.taskName);
  TextEditingController taskDescriptionController =
      TextEditingController(text: model.taskDescription);
  GlobalKey<FormState> key = GlobalKey<FormState>();
  bool isHighPriorty = model.isHighyPriority;
  return showModalBottomSheet<bool>(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    CustomTextFormField(
                        title: 'Task Name',
                        controller: taskNameController,
                        hintText: "Finish UI design for login screen",
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please Enter Your Task Name";
                          } else {
                            return null;
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                      title: 'Task Description',
                      controller: taskDescriptionController,
                      hintText:
                          "Finish onboarding UI and hand off to\n devs by Thursday.",
                      maxLines: 5,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "High Priority ",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Spacer(),
                        Switch(
                          value: isHighPriorty,
                          onChanged: (bool value) {
                            setState(() {
                              isHighPriorty = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Spacer(),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (key.currentState?.validate() ?? false) {
                          final taskJson =
                              PreferencesManager().getString(StorageKey.tasks);
                          List<dynamic> listTasks = [];
                          if (taskJson != null) {
                            listTasks = jsonDecode(taskJson);
                          }
                          TaskModel newModel = TaskModel(
                            id: model.id,
                            taskName: taskNameController.text,
                            taskDescription: taskDescriptionController.text,
                            isHighyPriority: isHighPriorty,
                            isDone: model.isDone,
                          );
                          final item =
                              listTasks.firstWhere((e) => e['id'] == model.id);
                          final int index = listTasks.indexOf(item);
                          listTasks[index] = newModel;
                          final taskEncode = jsonEncode(listTasks);
                          await PreferencesManager()
                              .setString(StorageKey.tasks, taskEncode);

                          Navigator.of(context).pop(true); // return home screen
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            100,
                          ),
                        ),
                      ),
                      label: Text(
                        "Edit Task",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      icon: Icon(
                        Icons.edit,
                        color: Color(0xFFFFFCFC),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      });
}
