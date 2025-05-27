import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/models/category_model.dart';
import 'package:flutter_todo_app/models/task_model.dart';
import 'package:flutter_todo_app/database/task_database.dart';
import 'package:flutter_todo_app/home/widgets/add_task_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class TaskDetailDialog extends StatelessWidget {
  final TaskModel task;
  final CategoryModel? category;
  final VoidCallback? onDelete;
  final VoidCallback? onEditSuccess;

  const TaskDetailDialog({
    super.key,
    required this.task,
    this.category,
    this.onDelete,
    this.onEditSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: tdGrey,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: showDescription(context),
        ),
      ),
    );
  }

  List<Widget> showDescription(BuildContext context) {
    return [
      title(),
      const SizedBox(height: 6),
      const Divider(color: Colors.white24, thickness: 1),
      const SizedBox(height: 12),
      dateTime(),
      const SizedBox(height: 12),
      if (task.description.isNotEmpty)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            task.description,
            style: const TextStyle(
              fontSize: 16,
              color: tdText,
            ),
          ),
        ),
      const SizedBox(height: 24),
      buttonUpdate(context),
    ];
  }

  Widget buttonUpdate(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
          onPressed: () async {
            final updated = await showModalBottomSheet<TaskModel>(
              context: context,
              isScrollControlled: true,
              backgroundColor: tdGrey,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (context) => AddTaskBottomSheet(
                existingTask: task,
                onTaskAdded: () async {
                  onEditSuccess?.call();
                  Navigator.pop(context);
                },
              ),
            );
            if (updated != null) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.edit, color: Colors.white, size: 20),
          label: Text('Edit'.tr(), style: const TextStyle(color: Colors.white, fontSize: 18)),
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: () async {
            await TaskDatabase.instance.deleteTask(task.id!);
            onDelete?.call();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
          label: Text('Delete'.tr(), style: const TextStyle(color: Colors.redAccent, fontSize: 18)),
        ),
      ],
    );
  }

  Widget dateTime() {
    return Row(
      children: [
        const Icon(Icons.calendar_today, color: tdText, size: 20),
        const SizedBox(width: 8),
        Text(
          '${task.dateTime.toLocal()}'.split(' ')[0],
          style: const TextStyle(color: tdText, fontSize: 16),
        ),
        const SizedBox(width: 8),
        Text(
          '${task.dateTime.hour.toString().padLeft(2, '0')}:${task.dateTime.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(color: tdText, fontSize: 16),
        ),
      ],
    );
  }

  Widget title() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            task.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        if (category != null) ...[
          const SizedBox(width: 12),
          _buildCategoryInfo(),
        ],
        const SizedBox(width: 12),
        _buildPriorityInfo(),
      ],
    );
  }

  Widget _buildPriorityInfo() {
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
      width: 120, 
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _buildCategoryInfo() {
    final cat = category!;
    return Container(
      width: 80, 
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Color(cat.color),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            cat.icon,
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              cat.label,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
