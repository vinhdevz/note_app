import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/home/widgets/add_task_screen.dart';
import 'package:flutter_todo_app/models/category_model.dart';
import 'package:flutter_todo_app/models/task_model.dart';
import 'package:flutter_todo_app/database/task_database.dart';
import 'package:easy_localization/easy_localization.dart';

class TaskCard extends StatefulWidget {
  final TaskModel task;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final CategoryModel? category;

  const TaskCard({
    super.key,
    required this.task,
    this.category,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late TaskModel _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

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
          _buildCompletionCheckbox(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleRow(),
                const SizedBox(height: 2),
                time(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionCheckbox() {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () async {
          final updatedTask = _task.copyWith(isCompleted: !_task.isCompleted);
          await TaskDatabase.instance.updateTask(updatedTask);
          setState(() => _task = updatedTask);
          widget.onDelete?.call();
        },
        child: Container(
          width: 22,
          height: 22,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: tdPurple, width: 2),
            color: _task.isCompleted ? tdPurple : Colors.transparent,
          ),
          child: _task.isCompleted
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : null,
        ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildTitleDescription()),
        const SizedBox(width: 16),
        if (widget.category != null) ...[
          categoryInTask(),
          const SizedBox(width: 12),
        ],
        priorityInTask(),
      ],
    );
  }

  Widget _buildTitleDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: _task.title,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  decoration: _task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              if (_task.description.isNotEmpty)
                TextSpan(
                  text: ' - ${_task.description}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    decoration: _task.isCompleted
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
    );
  }

  Widget priorityInTask() {
    Color bgColor;
    Color iconColor;

    switch (_task.priority) {
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

    String priorityText = _task.priority == 1
        ? 'Easy'.tr()
        : _task.priority == 2
            ? 'Normal'.tr()
            : 'Hard'.tr();

    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: Colors.black),
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

  Widget categoryInTask() {
    final category = widget.category!;
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Color(category.color),
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            category.icon,
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              category.label,
              style: const TextStyle(color: Colors.black, fontSize: 14),
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
          '${_task.dateTime.toLocal()}'.split(' ')[0],
          style: const TextStyle(color: Color(0xffAFAFAF), fontSize: 12),
        ),
        const SizedBox(width: 8),
        Text(
          '${_task.dateTime.hour.toString().padLeft(2, '0')}:${_task.dateTime.minute.toString().padLeft(2, '0')}',
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
                onTaskAdded: () async {
                  final updated = await TaskDatabase.instance.readTaskById(_task.id!);
                  if (updated != null) {
                    setState(() => _task = updated);
                  }
                  widget.onDelete?.call(); 
                },
                existingTask: _task,
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
          onPressed: () async {
            await TaskDatabase.instance.deleteTask(_task.id!);
            widget.onDelete?.call();
          },
        ),
      ],
    );
  }
}
