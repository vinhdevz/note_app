import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/home/widgets/add_task_screen.dart';
import 'package:flutter_todo_app/models/task_model.dart';
import 'package:flutter_todo_app/database/task_database.dart';
import 'package:easy_localization/easy_localization.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E2E),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () async {
                final updatedTask =
                    task.copyWith(isCompleted: !task.isCompleted);
                await TaskDatabase.instance.updateTask(updatedTask);
                if (onDelete != null) {
                  onDelete!();
                }
              },
              child: Container(
                width: 22,
                height: 22,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: tdPurple, width: 2),
                  color: task.isCompleted ? tdPurple : Colors.transparent,
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: task.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                if (task.description.isNotEmpty)
                                  TextSpan(
                                    text: ' - ${task.description}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    priorityInTask(),
                  ],
                ),
                const SizedBox(height: 2),
                time(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget priorityInTask() {
  Color bgColor;
  Color iconColor;

  switch (task.priority) {
    case 1:
      bgColor = priEasy;
      iconColor = iconEasy;
      break;
    case 2:
      bgColor = priNormal;
      iconColor = iconNormal;
      break;
    case 3:
      bgColor = priHard;
      iconColor = iconHard;
      break;
    default:
      bgColor = Colors.grey;
      iconColor = Colors.grey;
  }

  String priorityText = task.priority == 1
      ? 'Easy'.tr()
      : task.priority == 2
          ? 'Normal'.tr()
          : 'Hard'.tr();

  return Container(
    width: 125, 
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    decoration: BoxDecoration(
      color: bgColor,
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center, // căn giữa nội dung
      children: [
        SvgPicture.asset(
          'assets/icons/flag.svg',
          width: 16,
          height: 16,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            priorityText,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}


  Widget time(BuildContext context) {
    return Row(
      children: [
        Text(
          '${task.dateTime.toLocal()}'.split(' ')[0],
          style: const TextStyle(color: Color(0xffAFAFAF), fontSize: 12),
        ),
        const SizedBox(width: 8),
        Text(
          '${task.dateTime.hour.toString().padLeft(2, '0')}:${task.dateTime.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(color: Color(0xffAFAFAF), fontSize: 12),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white, size: 20),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: tdGrey,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (context) => AddTaskBottomSheet(
                onTaskAdded: () {
                  if (onDelete != null) {
                    onDelete!();
                  }
                },
                existingTask: task,
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
          onPressed: () async {
            await TaskDatabase.instance.deleteTask(task.id!);
            if (onDelete != null) {
              onDelete!();
            }
          },
        ),
      ],
    );
  }
}
