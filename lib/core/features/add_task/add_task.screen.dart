import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/features/add_task/add_task_controller.dart';
import 'package:tasky/core/widgets/custom_text_form_field.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext _) {
    return ChangeNotifierProvider<AddTaskController>(
      create: (_) => AddTaskController(),
      builder: (context, _) {
        final controller = context.read<AddTaskController>();
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
                key: controller.key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                        title: 'Task Name',
                        controller: controller.taskNameController,
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
                      controller: controller.taskDescriptionController,
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
                        Consumer<AddTaskController>(
                          builder: (BuildContext context,
                              AddTaskController value, Widget? child) {
                            return Switch(
                              value: value.isHighPriorty,
                              onChanged: (bool value) {
                                controller.toggle(value);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    Spacer(),
                    ElevatedButton.icon(
                      onPressed: () async {
                        context.read<AddTaskController>().AddTask(context);
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
      },
    );
  }
}
