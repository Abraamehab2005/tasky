import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/widgets/custom_text_form_field.dart';
import 'package:tasky/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  bool isHighPriorty = true;

  //!TODO : DISPOSE THIS CONTROLLERS
  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController taskDescriptionController =
      TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Task",
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    //Spacer(),
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
                    if (_key.currentState?.validate() ?? false) {
                      final taskJson =
                          PreferencesManager().getString("tasks");
                      List<dynamic> listTasks = [];
                      if (taskJson != null) {
                        listTasks = jsonDecode(taskJson);
                      }
                      TaskModel model = TaskModel(
                        id: listTasks.length + 1,
                        taskName: taskNameController.text,
                        taskDescription: taskDescriptionController.text,
                        isHighyPriority: isHighPriorty,
                      );
            
                      listTasks.add(model.toJson());
            
                      final taskEncode = jsonEncode(listTasks);
                      await PreferencesManager()
                          .setString("tasks", taskEncode);
            
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
                    "Add Task",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  icon: Icon(
                    Icons.add,
                    color: Color(0xFFFFFCFC),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}