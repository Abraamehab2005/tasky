import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/features/home/home_controller.dart';
import 'package:tasky/core/components/task_item_widget.dart';

class SliverTaskListWidget extends StatelessWidget {
  const SliverTaskListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder:
          (BuildContext context, HomeController controller, Widget? child) {
        final tasksList = controller.tasks;
        return controller.isLoading
            ? SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              )
            : tasksList.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'No Data',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 33, 5, 5),
                            fontSize: 24),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: EdgeInsets.only(bottom: 80),
                    sliver: SliverList.separated(
                      itemCount: tasksList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: TaskItemWidget(
                            model: tasksList[index],
                            onChanged: (bool? value) {
                              controller.doneTask(value, index);
                            },
                            onDelete: (int id) {
                              controller.deleteTask(id);
                            },
                            onEdit: () {
                              controller.loadTask();
                            },
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 8,
                        );
                      },
                    ),
                  );
      },
    );
  }
}
