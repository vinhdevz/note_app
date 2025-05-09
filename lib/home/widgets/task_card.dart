import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/models/task_model.dart';
import 'package:flutter_todo_app/database/task_database.dart';


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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E2E),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Flag
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Flag Icon
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: tdPurple),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/flag.svg',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${task.priority}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Date & Time + Edit/Delete buttons
          Row(
            children: [
              Text(
                '${task.dateTime.toLocal()}'.split(' ')[0], // Show date only
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
                onPressed: onEdit, 
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
          ),
        ],
      ),
    );
  }
}
