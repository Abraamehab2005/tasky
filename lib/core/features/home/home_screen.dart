import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/widgets/custom_svg_picture.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/core/features/add_task/add_task.screen.dart';
import 'package:tasky/widgets/archieved_tasks_widget.dart';
import 'package:tasky/widgets/high_priority_tasks_widget.dart';
import 'package:tasky/widgets/sliver_task_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username = "Default";
  String? userImagePath;
  int totalTask = 0;
  int totalDoneTasks = 0;
  double percent = 0;
  List<TaskModel> tasks = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadTask();
  }

  void _loadTask() async {
    // setState(() { //!i donot need to load remember this
    //   isLoading = true;
    // });

    final fianlTask = PreferencesManager().getString("tasks");
    if (fianlTask != null) {
      final taskAfterDecode = jsonDecode(fianlTask) as List<dynamic>;
      setState(() {
        tasks = taskAfterDecode.map((element) {
          return TaskModel.fromJson(element);
        }).toList();
        _calculatePercent();
        // setState(() {
        //   isLoading = false;
        // });
      });
    }
  }

  _calculatePercent() {
    totalTask = tasks.length;
    totalDoneTasks = tasks.where((e) => e.isDone).length;
    percent = totalTask == 0 ? 0 : totalDoneTasks / totalTask;
  }

  _doneTask(bool? value, int? index) async {
    setState(() {
      tasks[index!].isDone = value ?? false;
      _calculatePercent();
    });

    final updatedTask = tasks.map((element) => element.toJson()).toList();
    await PreferencesManager().setString("tasks", jsonEncode(updatedTask));
  }

  void _loadUserName() async {
    setState(() {
      username = PreferencesManager().getString('username');
      userImagePath = PreferencesManager().getString('user_image');
    });
  }

  _deleteTask(int? id) async {
    if (id == null) return;
    setState(() {
      tasks.removeWhere((task) => task.id == id);
      _calculatePercent();
    });
    // todo : make shared method
    final updatedTasks = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString('tasks', jsonEncode(updatedTasks));
  }

  @override
  Widget build(BuildContext context) {
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
              _loadTask();
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
                        backgroundImage: userImagePath == null
                            ? AssetImage(
                                'assets/images/Person.png',
                              )
                            : FileImage(File(userImagePath!)),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Evening ,$username",
                            style: Theme.of(context).textTheme.titleMedium,
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
                    totalTask: totalTask,
                    totalDoneTasks: totalDoneTasks,
                    percent: percent,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  HighPriorityTasksWidget(
                    tasks: tasks,
                    onTap: (bool? value, int? index) {
                      _doneTask(value, index);
                    },
                    refresh: () {
                      _loadTask();
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
            isLoading
                ? SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )
                : SliverTaskListWidget(
                    tasks: tasks,
                    onTap: (bool? value, int? index) {
                      _doneTask(value, index);
                    },
                    emptyMessage: 'No Data',
                    onDelete: (int? id) {
                      _deleteTask(id);
                    },
                    onEdit: () {
                      _loadTask();
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
