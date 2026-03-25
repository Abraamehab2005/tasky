import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/features/home/home_controller.dart';
import 'package:tasky/core/widgets/custom_svg_picture.dart';
import 'package:tasky/core/features/add_task/add_task.screen.dart';
import 'package:tasky/core/features/home/components/archieved_tasks_widget.dart';
import 'package:tasky/core/features/home/components/high_priority_tasks_widget.dart';
import 'package:tasky/core/features/home/components/sliver_task_list_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (BuildContext context) => HomeController(),
      child: Consumer<HomeController>(
        builder: (BuildContext context, HomeController value, Widget? child) {
          final controller = context.read<HomeController>();
          return Scaffold(
            floatingActionButton: SizedBox(
              height: 44,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  final bool? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return AddTaskScreen();
                      },
                    ),
                  );
                  if (result != null && result) {
                    controller.loadTask();
                  }
                },
                label: Text(
                  'Add New Task',
                ),
                icon: Icon(
                  Icons.add,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: value.userImagePath == null
                                  ? AssetImage(
                                      'assets/images/Person.png',
                                    )
                                  : FileImage(File(value.userImagePath!)),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Good Evening ,${value.username}",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "One task at a time.One step closer.",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Yuhuu ,Your work Is ",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Row(
                          children: [
                            Text(
                              "almost done ! ",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            CustomSvgPicture.withoutColor(
                                path: 'assets/images/waving-hand.svg')
                          ],
                        ),
                        SizedBox(height: 16),
                        ArchievedTasksWidget(
                          totalTask: value.totalTask,
                          totalDoneTasks: value.totalDoneTasks,
                          percent: value.percent,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        HighPriorityTasksWidget(
                          tasks: value.tasks,
                          onTap: (bool? value, int? index) {
                            controller.doneTask(value, index);
                          },
                          refresh: () {
                            controller.loadTask();
                          },
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 16),
                          child: Text(
                            "My Tasks",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  value.isLoading
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : SliverTaskListWidget(
                          tasks: value.tasks,
                          onTap: (bool? value, int? index) {
                            controller.doneTask(value, index);
                          },
                          emptyMessage: 'No Data',
                          onDelete: (int? id) {
                            controller.deleteTask(id);
                          },
                          onEdit: () {
                            controller.loadTask();
                          },
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
