import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';
import 'package:tasky/core/features/home/home_controller.dart';

class ArchievedTasksWidget extends StatelessWidget {
  const ArchievedTasksWidget({
    super.key,
    //required this.totalTask,
    // required this.totalDoneTasks,
    // required this.percent,
  });
  // final int totalTask;
  // final int totalDoneTasks;
  // final double percent;
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder:
          (BuildContext context, HomeController controller, Widget? child) {
        return Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
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
                    height: 4,
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
                      height: 48,
                      width: 48,
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
        );
      },
    );
  }
}
