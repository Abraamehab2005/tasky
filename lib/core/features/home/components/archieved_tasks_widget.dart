import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_size.dart';
import 'package:tasky/core/features/tasks/tasks_controller.dart';

class ArchievedTasksWidget extends StatelessWidget {
  const ArchievedTasksWidget({
    super.key,
    
  });
 
  @override
  Widget build(BuildContext context) {
    return Consumer<TasksController>(
      builder:
          (BuildContext context, TasksController controller, Widget? child) {
        return Container(
          padding: EdgeInsets.all(AppSize.pw16), 
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.r20),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Padding(
            padding:  EdgeInsets.all(AppSize.w16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Achieved Tasks',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(
                      height: AppSize.h4,
                    ),
                    Text(
                      '${controller.totalDoneTasks} Out of ${controller.totalTask} Done',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: -math.pi / 2,
                      child: SizedBox(
                        height: AppSize.h48, 
                        width: AppSize.w48, 
                        child: CircularProgressIndicator(
                          backgroundColor: Color(0xFF6D6D6D),
                          valueColor: AlwaysStoppedAnimation(
                            Color(
                              0xFF15B86C,
                            ),
                          ),
                          strokeWidth: 4,
                          value: controller.percent,
                        ),
                      ),
                    ),
                    Text(
                      "${((controller.percent * 100).toInt())} %",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
